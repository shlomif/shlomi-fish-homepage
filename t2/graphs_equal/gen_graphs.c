#include <stdlib.h>
#include <stdio.h>

#ifdef _MSC_VER
typedef __int64 integer64;
#define INT64_CONSTANT(c) (c##i64)
#elif defined(__GNUC__)
typedef __int64_t integer64;
#define INT64_CONSTANT(c) (c##ll)
#endif

struct struct_pysol_random_context
{
    integer64 seed;
    double (*random)(struct struct_pysol_random_context *); 
    int (*randint)(struct struct_pysol_random_context *, int a, int b);
};

typedef struct struct_pysol_random_context pysol_random_context;

int pysol_random64_randint(pysol_random_context * context, int a, int b)
{
    return (a + (int)(context->random(context) * (b+1-a)));
}


double pysol_random64(pysol_random_context * context)
{
    context->seed = (context->seed*INT64_CONSTANT(6364136223846793005) + INT64_CONSTANT(1)) & INT64_CONSTANT(0xffffffffffffffff);
    return ((context->seed >> 21) & INT64_CONSTANT(0x7fffffff)) / 2147483648.0;
}

double pysol_random31(pysol_random_context * context)
{
    context->seed = (context->seed*INT64_CONSTANT(214013) + INT64_CONSTANT(2531011)) &  INT64_CONSTANT(0x7fffffff);
    return (context->seed >> 16) / 32768.0;
}

int pysol_random31_randint(pysol_random_context * context, int a, int b)
{
    context->seed = (context->seed*INT64_CONSTANT(214013) + INT64_CONSTANT(2531011)) & INT64_CONSTANT(0x7fffffff);
    return a + (((int)(context->seed >> 16)) % (b+1-a));
}

typedef int node_t;

typedef node_t * * graph_t;

graph_t create_graph(int num_nodes)
{
    graph_t ret;
    int a, b;

    ret = malloc(sizeof(node_t *) * num_nodes);
    for(a=0;a<num_nodes;a++)
    {
        ret[a] = malloc(sizeof(node_t)*num_nodes);
        for(b=0;b<num_nodes;b++)
        {
            ret[a][b] = 0;
        }
    }
    return ret;
}
        
void destroy_graph(int num_nodes, graph_t graph)
{
    int a;
    for(a=0;a<num_nodes;a++)
    {
        free(graph[a]);
    }
    free(graph);
}

graph_t generate_random_graph(int num_nodes, int num_links, pysol_random_context * r)
{
    graph_t graph;
    int a, node, to_node;

    graph = create_graph(num_nodes);

    for(a=0;a<num_links;a++)
    {
        node = (r->randint(r, 0, num_nodes-1));
        to_node = (r->randint(r, 0, num_nodes-1));
        if (node == to_node)
        {
            graph[node][to_node]++;
        }
        else
        {
            graph[node][to_node]++;
            graph[to_node][node]++;
        }
    }

    return graph;
}

int write_graph_to_file(char * filename, int num_nodes, graph_t graph)
{
    FILE * o;
    int node, to_node;
    node_t a;

    o = fopen(filename, "wt");
    if (o == NULL)
    {
        return 1;
    }

    fprintf(o, "%i\n", num_nodes);
    for(node=0;node<num_nodes;node++)
    {
        for(to_node=node;to_node<num_nodes;to_node++)
        {
            for(a=0;a<graph[node][to_node];a++)
            {
                fprintf(o, "%i -> %i\n", node, to_node);
            }
        }
    }

    fclose(o);

    return 0;
}

int main(int argc, char * argv[])
{
    int seed;
    int num_nodes;
    pysol_random_context r;
    int a;
    graph_t graph;
    char filename[80];

    if (argc > 1)
    {
        seed = atoi(argv[1]);
    }
    
    num_nodes = 15;

    r.seed = seed;
    r.random = pysol_random64;
    r.randint = pysol_random64_randint;

    for(a=0;a<100;a++)
    {
        graph = generate_random_graph(num_nodes, 35, &r);
        sprintf(
            filename, 
            "test_graph.%i.txt", 
            a);
        write_graph_to_file(filename, num_nodes, graph);
        destroy_graph(num_nodes, graph);
    }

    return 0;
}

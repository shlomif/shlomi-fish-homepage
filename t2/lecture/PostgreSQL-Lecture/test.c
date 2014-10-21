#include <stdio.h>
#include "libpq-fe.h"

void
exit_nicely(PGconn * conn)
{
    PQfinish(conn);
    exit(1);
}

int main()
{
    char * pghost, * pgport, * pgoptions, * pgtty;
    char * dbName;

    char name[256];

    int i, num_records;

    PGconn * conn;
    PGresult * res;

    pghost = NULL;
    pgport = NULL;
    pgoptions = NULL;
    pgtty = NULL;

    dbName = "test";

    conn = PQsetdb(pghost, pgport, pgoptions, pgtty, dbName);

    if (PQstatus(conn) == CONNECTION_BAD)
    {
        fprintf(stderr, "Connection to database \"%s\" failed.\n", dbName);
        fprintf(stderr, "%s", PQerrorMessage(conn));
        exit_nicely(conn);
    }

    res = PQexec(conn, "SET DateStyle = 'European'");

    if ((!res) || (PQresultStatus(res) != PGRES_COMMAND_OK))
    {
        fprintf(stderr, "SET command failed\n");
        PQclear(res);
        exit_nicely(conn);
    }
    PQclear(res);

    res = PQexec(conn,
        "SELECT first_name, last_name, hired_at"
        " FROM employees"
        " ORDER BY last_name, first_name"
    );
    if ((!res) || (PQresultStatus(res) != PGRES_TUPLES_OK))
    {
        fprintf(stderr, "SELECT command did not return tuples properly\n");
        PQclear(res);
        exit_nicely(conn);
    }

    printf("%-40s%-20s\n", "Name:", "Hired At:");
    for(i=0;i<60;i++)
    {
        printf("-");
    }
    printf("\n");

    num_records = PQntuples(res);

    for(i = 0 ; i < num_records ; i++)
    {
        sprintf(name, "%s %s", PQgetvalue(res, i, 0), PQgetvalue(res, i, 1));
        printf("%-40s%-20s\n", name, PQgetvalue(res, i, 2));
    }

    PQclear(res);

    PQfinish(conn);

    return 0;

}


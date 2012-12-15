'users' =>
{
    'fields' =>
    [
        {
            'name' => "User_ID",
            'type' => "int32",
            'input' => { 'type' => "auto", 'method' => "get-new-id", "primary_key" => 1, },
            'display' => { 'type' => "hidden" },
        },
        {
            'name' => 'Name',
            'type' => "varchar",
            'type_params' => { 'len' => 255 },
        },
        {
            'name' => 'Username',
            'type' => "varchar",
            'type_params' => { 'len' => 30 },
            'input_params' =>
            [
                {
                    'type' => 'unique',
                },
                {
                    'type' => "not_match",
                    'regex' => '^new$',
                    'comment' => "new is a reserved word and cannot be assigned as a username",
                },
                {
                    'type' => 'match',
                    'regex' => '^[a-zA-Z]\w*$' ,
                    'comment' => "The username must start with a letter and extend with letters, digits and underscores",
                },

           ],
           'display' => { 'type' => "constant" },
        },
        {
            'name' => "Super_Admin",
            'title' => "Super Admin Flag",
            'type' => "bool",
            'input' => { 'type' => "auto", 'method' => "by-value", 'value' => 0}
        },
        {
            'name' => "Password",
            'type' => "varchar",
            'type_params' => { 'len' => 255 },
            'display' => {'type' => "password" },
        },
        {
            'name' => "Email",
            'title' => "E-Mail",
            'type' => "email",
            'type_params' => { 'len' => 255 },
        },
    ],
    'derived-tables' => [ "permissions" ],
    'triggers' =>
    {
        'add' =>
        [
            "INSERT INTO permissions (User_ID, Club_ID, Seminars, Subjects) SELECT \$F{User_ID}, clubs.Club_ID, 0, 0 FROM clubs",
        ],
        'delete' =>
        [
            "DELETE FROM permissions WHERE User_ID = \$F{User_ID}",
        ],
    },
}

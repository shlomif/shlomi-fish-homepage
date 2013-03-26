#!/usr/bin/perl

use DBI;

use strict;

my $conn = DBI->connect("dbi:Pg:dbname=test");

my ($first_name, $last_name, $hired_at);
my (@row);

$conn->do("SET DateStyle = 'European'");

my $query = $conn->prepare(
    "SELECT first_name, last_name, hired_at" .
    " FROM employees" .
    " ORDER BY last_name, first_name"
    );
$query->execute();

print sprintf("%-40s%-20s", "Name:", "Hired At:"), "\n";
print "-" x 60 . "\n";
while (@row = $query->fetchrow_array())
{
    ($first_name, $last_name, $hired_at) = @row;

    print sprintf("%-40s%-20s", $first_name . " " . $last_name, $hired_at),
        "\n";
}

undef($query);
$conn->disconnect();
$conn = undef;

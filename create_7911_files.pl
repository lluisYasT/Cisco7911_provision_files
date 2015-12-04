#!/bin/env perl
use strict;

use Template;
use DBI;

my $host = "127.0.0.1";
my $port = 3306;
my $database = "asterisk";
my $dsn = "dbi:mysql:database=$database;host=$host;port=$port";
my $user = "root";
my $password = "";

my $dbh = DBI->connect($dsn, $user, $password,
                    { RaiseError => 1, AutoCommit => 0});

open(my $mac_file, '<','extensiones_7911.csv');

$mac_file->close;
$dbh->disconnect;

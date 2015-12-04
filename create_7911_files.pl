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

my $sip_server = "172.16.0.1";

my $dbh = DBI->connect($dsn, $user, $password,
                    { RaiseError => 1, AutoCommit => 0});

my $template_config = {
  INTERPOLATE => 1,
  POST_CHOMP  => 1,
  EVAL_PERL   => 1,
  OUTPUT_PATH => 'config_files/'
};

my $template = Template->new($template_config);

open(my $mac_file, '<','extensiones_7911.csv');

foreach my $line (<$mac_file>) {
  chomp $line;
  (my $extension, my $mac) = split(/,/,$line);
  my $sth = $dbh->prepare("SELECT data FROM sip WHERE keyword='secret' AND id=$extension");
  $sth->execute();
  (my $password) = $sth->fetchrow_array();

  my $vars = {
    extension => $extension,
    password  => $password,
    server    => $sip_server,
  };

  my $input = 'template.cnf.xml';

  $template->process($input, $vars, "SEP$mac.cnf.xml") || die $template->error();

}

$mac_file->close;
$dbh->disconnect;

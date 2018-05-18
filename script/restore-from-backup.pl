#!/usr/bin/env perl

use 5.20.0;
use experimental 'signatures';
use warnings;
no warnings 'experimental';
use autodie;

use Data::Dump 'pp';
my $dir = "db_backups";

my $dumpfile = "$dir/" . `ls -1t $dir/ | head -n 1`;
chomp $dumpfile;

# pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump
my $database = "marysplace_dev";
my @restore_command = ( 'docker-compose',
                        'run',
                        'mp_postgres',
                        'pg_restore',
			"--verbose",
			"--clean",
			"--no-acl",
			"--no-owner",
                        "-h", "mp_postgres",
                        "-U", "postgres",
			"-d", $database,
			$dumpfile );

say "@restore_command";
if ( 0 == system @restore_command ) {
    say "$database now matches $dumpfile";
}
else {
    die "`@restore_command` failed: $?";
}

#!/usr/bin/env perl

use 5.20.0;
use warnings;

use DBI;
use Data::Printer;

my $term = shift;

die "Usage: $0 <term>" unless $term;

my $current_alias = $term;
my $starts_with   = "$term\%";
my $contains      = "\%$term\%";
my $ends_with     = "\%$term";

my $dsn        = "dbi:Pg:dbname=marysplace_dev";
my $dbh        = DBI->connect( $dsn, '', '', { RaiseError => 1 }  );

my $query =<<END_SQL
select 
  id, 
  current_alias, 
  full_name, 
  oriented_on, 
  created_at,
  updated_at
from 
  clients
where
  current_alias = ?
  or current_alias ilike ?
  or current_alias ilike ?
  or current_alias ilike ?
order by current_alias
END_SQL
;


my $sth = $dbh->prepare( $query );
$sth->execute(
  $current_alias,
  $starts_with,
  $contains,
  $ends_with,
);

while ( my $row = $sth->fetchrow_hashref ) {
  p $row;
}

$dbh->disconnect;

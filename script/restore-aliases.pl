#!/usr/bin/env perl

# OMG Some idiot (me) ran an anonymizer script on the production database. Luckily he made a backup right before.
# Unfortunately there've been writes since the anonymizer ran, so he can't just restore from backup.
#
# This script connects to both the healthy and sick databases, replacing client.current_alias in the sick with
# client.current_alias from healthy. 
use 5.18.0;
use warnings;

use DBI;
use Data::Dumper qw( Dumper );

my $EMPTY_STRING = q{};
my $CREDENTIALS_FILE = ".pg-credentials";

open my $sick_dsn_file, $CREDENTIALS_FILE
  or die "Unable to open [$CREDENTIALS_FILE]: $!";

my $sick_dsn = <$sick_dsn_file>;
chomp $sick_dsn;
close $sick_dsn_file;

my $healthy_dsn = "dbi:Pg:dbname=marysplace_dev";

my $queries = {
  examine_sick    => "SELECT id, current_alias FROM clients ORDER BY id",
  compare_healthy => "SELECT current_alias FROM clients WHERE id = ?",
  find_scars      => "SELECT id FROM clients WHERE current_alias = ?",
  heal_sick       => "UPDATE clients SET current_alias = ? WHERE id = ?",
};

my $sick_dbh     = DBI->connect( $sick_dsn, $EMPTY_STRING, $EMPTY_STRING, { RaiseError => 1 } );
my $healthy_dbh  = DBI->connect( $healthy_dsn, $EMPTY_STRING, $EMPTY_STRING, { RaiseError => 1 } );
my $examiner_sth = $sick_dbh->prepare( $queries->{examine_sick} );
my $comparer_sth = $healthy_dbh->prepare( $queries->{compare_healthy} );
my $scar_sth     = $sick_dbh->prepare( $queries->{find_scars} );
my $healing_sth  = $sick_dbh->prepare( $queries->{heal_sick} );

$examiner_sth->execute
  or die "Unable to examine sick database: ", $sick_dbh->errstr;

my $total_rows      = $examiner_sth->rows;
my $count_chars     = length $total_rows;
my $chars_format    = "%0${count_chars}d";
my $message_format  = "$chars_format / $chars_format";
my $examined_count  = 0;
my $sick_count      = 0;
my $scar_count      = 0;
my $heal_count      = 0;

while ( my $examined_row = $examiner_sth->fetchrow_hashref ) {
  $examined_count++;
  my $message    = sprintf $message_format, $examined_count, $total_rows;
  my $sick_id    = $examined_row->{id};
  my $sick_alias = $examined_row->{current_alias};
  my @notes;

  $comparer_sth->execute( $examined_row->{id} )
    or die "Unable to compare healthy database: ", $healthy_dbh->errstr;

  my $compared_row = $comparer_sth->fetchrow_hashref;
  my $healthy_alias = $compared_row->{current_alias};

  if ( $sick_alias ne $healthy_alias ) {
    $sick_count++;
    push @notes, "[$sick_alias] is not [$healthy_alias].";

    $scar_sth->execute( $healthy_alias )
      or die "Unable to find scars in sick database: ", $sick_dbh->errstr;

    my $scar_count = $scar_sth->rows;
    
    if ( $scar_count ) {
      $scar_count++;
      push @notes, "Scar found. Somebody recreated [$healthy_alias].";
    }
    else {
      $sick_dbh->begin_work;
      my $heal_succeeded = $healing_sth->execute( $healthy_alias, $sick_id );

      if ( $heal_succeeded ) {
        $sick_dbh->commit;
        $heal_count++;
        push @notes, "HEALED.";
      }
      else {
        $sick_dbh->rollback;
        push @notes, "Unable to heal:", $sick_dbh->errstr;
      }
    }

    $scar_sth->finish;
  }

  if ( @notes ) {
    $message .= " : $sick_id : @notes";
  }

  say $message;
}

say "Examined $examined_count of $total_rows clients.";
say "Found $sick_count incorrect aliases.";
say "Healed $heal_count.";
say "Found & skipped $scar_count attempts to correct made by users.";

$examiner_sth->finish;

$sick_dbh->disconnect;

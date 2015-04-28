use 5.20.0;
use experimental 'signatures';
use warnings;
no warnings 'experimental';

use Data::Dump 'pp';

my $heroku = "/usr/local/heroku/bin/heroku";
my $dir    = "db_backups";

sub grab_backup_for( $entry ) {
  my ( $id, $date, $time ) = @$entry;
  ( my $url = (split "\n", `$heroku pg:backups public-url $id`)[-1] ) =~ s/^\s+'(.+?)'$/$1/g;
  my $stub = join '-', $id, $date;
  my $dumpfile = "$dir/$stub.dump";

  if ( -f $dumpfile ) {
    say "$id -> $dumpfile already exists";
    return;
  }

  my $curl = "/usr/bin/curl";
  my @curl_command = ( $curl, "-o", $dumpfile, $url );
  say "@curl_command";

  if ( system @curl_command ) {
      die "`@curl_command` failed: $?";
  }

  say "$id -> $dumpfile downloaded";
}

my @entries = sort { $a->[1] cmp $b->[1] || $a->[2] cmp $b->[2] } # compare start date/times
          map  { [ (split)[ 0, 1, 2 ] ] } # name, date started, and time started.
          grep { $_ =~ /^([a-z]\d+)/ } # Where a backup is mentioned.
          split "\n", `$heroku pg:backups 2>/dev/null`;

my $entry_count = @entries;
say "$entry_count backups to check";

for my $entry ( @entries ) {
  grab_backup_for $entry;
}

my $dumpfile = "$dir/" . `ls -1t $dir/ | head -n 1`;
chomp $dumpfile;
say $dumpfile;

# pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump
my $database = "marysplace_dev";
my $pg_restore = "/opt/local/bin/pg_restore";
my @restore_command = ( $pg_restore,
			"--verbose",
			"--clean",
			"--no-acl",
			"--no-owner",
			"-h", "localhost",
			"-d", $database,
			$dumpfile );

say "@restore_command";
if ( 0 == system @restore_command ) {
    say "$database now matches $dumpfile";
}
else {
    die "`@restore_command` failed: $?";
}

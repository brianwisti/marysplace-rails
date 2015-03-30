use 5.20.0;
use experimental 'signatures';
use warnings;
no warnings 'experimental';

use Data::Dump 'pp';

my $heroku = "/usr/local/heroku/bin/heroku";
my $dir    = "db_backups";

sub grab_backup_for( $id ) {
  ( my $url = (split "\n", `$heroku pg:backups public-url $id`)[-1] ) =~ s/^\s+'(.+?)'$/$1/g;
  my $dumpfile = "$dir/$id.dump";

  if ( -f $dumpfile ) {
    say "$id -> $dumpfile already exists";
    return;
  }

  my $curl = "/opt/local/bin/curl";
  my @curl_command = ( $curl, "-o", $dumpfile, $url );
  say "@curl_command";

  if ( system @curl_command ) {
      die "`@curl_command` failed: $?";
  }

  say "$id -> $dumpfile downloaded";
}

my @ids = map  { (split)[0]      } # From the first column of each line
          grep { $_ =~ /^(b\d+)/ } # Where a backup is mentioned.
          split "\n", `$heroku pg:backups 2>/dev/null`;

my $id_count = @ids;
say "$id_count backups to check";

for my $id ( @ids ) {
  grab_backup_for $id;
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

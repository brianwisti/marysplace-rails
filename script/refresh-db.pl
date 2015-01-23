use 5.20.0;
use warnings;

my $heroku = "/usr/local/heroku/bin/heroku";

my $url = `$heroku pgbackups:url`;
chomp $url;

my $dumpfile;

if ( $url =~ m{com/ (b\d\d\d\.dump) \?}x ) {
    $dumpfile = $1;
}
else {
    die "I can't find a dumpfile in '$url'";
}

unless ( -f $dumpfile ) {
    my $curl = "/opt/local/bin/curl";
    my @curl_command = ( $curl, "-o", $dumpfile, $url );
    say "@curl_command";

    if ( system @curl_command ) {
	die "`@curl_command` failed: $?";
    }
}

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

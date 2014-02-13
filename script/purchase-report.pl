use 5.18.0;
use warnings;

use Text::CSV;
use DBI;
use Data::Dumper qw( Dumper );

my $dsn = "dbi:Pg:dbname=marysplace_dev";
my $dbh = DBI->connect( $dsn, '', '', { RaiseError => 1 }  );

my $query =<<END_SQL;
select
  entry.performed_on,
  client.current_alias,
  u.login as added_by,
  entry.points
from
  points_entries entry
inner join points_entry_types entry_type
  on entry_type.id = entry.points_entry_type_id
  and entry_type.name = 'Purchase'
inner join clients client
  on entry.client_id = client.id
inner join users u
  on u.id = entry.added_by_id
order by
  entry.performed_on ASC
END_SQL
;

my $sth = $dbh->prepare( $query );
$sth->execute;

my $csv = Text::CSV->new;

while ( my $row = $sth->fetchrow_hashref ) {
  my @columns = (
    $row->{performed_on},
    $row->{current_alias},
    $row->{added_by},
    $row->{points},
  );
  $csv->combine( @columns );
  say $csv->string;
}

$dbh->disconnect;


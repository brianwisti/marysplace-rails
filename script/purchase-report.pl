use 5.18.0;
use warnings;

use DBI;
use Excel::Writer::XLSX;

my $start_date = '2013-01-01';
my $end_date   = '2013-12-31';
my $dsn        = "dbi:Pg:dbname=marysplace_dev";
my $dbh        = DBI->connect( $dsn, '', '', { RaiseError => 1 }  );

write_entries( $dbh, $start_date, $end_date );

$dbh->disconnect;

sub load_entries {
  my ( $dbh, $start_date, $end_date ) = @_;

  my $query =<<END_SQL;
  select
    entry.performed_on   as performed_on,
    extract(month from entry.performed_on) as month,
    client.current_alias as current_alias,
    u.login              as added_by,
    entry.points         as points
  from
    points_entries entry
  inner join points_entry_types entry_type
    on entry_type.id = entry.points_entry_type_id
    and entry_type.name = 'Purchase'
  inner join clients client
    on entry.client_id = client.id
  inner join users u
    on u.id = entry.added_by_id
  where entry.performed_on >= ?
    and entry.performed_on <= ?
  order by
    entry.performed_on ASC
END_SQL
  ;

  my $sth = $dbh->prepare( $query );
  $sth->execute( $start_date, $end_date );
  return $sth;
}

sub write_entries {
  my ( $dbh, $start_date, $end_date ) = @_;
  my $sth = load_entries( $dbh, $start_date, $end_date );

  my $workbook = Excel::Writer::XLSX->new( 'purchase-report.xlsx' )
    or die "Unable to create 'purchase-report.xlsx': $!";
  my $summaries_worksheet = $workbook->add_worksheet();
  my $entries_worksheet   = $workbook->add_worksheet();

  my $total_for = {};
  my $entry_row = 0;

  while ( my $row = $sth->fetchrow_hashref ) {
    my $month  = $row->{month};
    my $points = $row->{points};

    if ( exists $total_for->{ $month } ) {
      $total_for->{ $month }{entries}++;
      $total_for->{ $month }{points} += $points;
    }
    else {
      $total_for->{ $month } = { entries => 1, points => $points };
    }

    my @columns = (
      $row->{performed_on},
      $row->{current_alias},
      $row->{added_by},
      $points,
    );

    for my $i ( 0 .. $#columns ) {
      $entries_worksheet->write( $entry_row, $i, $columns[ $i ] );
    }

    $entry_row++;
  }

  my $summary_row = 0;
  my $total_points = 0;
  my $total_entries = 0;

  for my $month ( sort { $a <=> $b } keys %{ $total_for } ) {
    my $entries = $total_for->{ $month }{entries};
    my $points = $total_for->{ $month }{points};
    $total_points += $points;
    $total_entries += $entries;
    $summaries_worksheet->write( $summary_row, 0, "$month/2013" );
    $summaries_worksheet->write( $summary_row, 1, $entries      );
    $summaries_worksheet->write( $summary_row, 2, $points       );
    $summary_row++;
  };

  my $total_row = $summary_row + 2; # whitespace formatting.
  $summaries_worksheet->write( $total_row, 0, "Total"        );
  $summaries_worksheet->write( $total_row, 1, $total_entries );
  $summaries_worksheet->write( $total_row, 2, $total_points  );
}

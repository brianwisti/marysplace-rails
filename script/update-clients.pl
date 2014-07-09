use 5.20.0;
use warnings;

use DBI qw(:sql_types);
use Spreadsheet::Read;
use Try::Tiny;
use DateTime::Format::Excel;
use Data::Printer;

my $dsn        = "dbi:Pg:dbname=marysplace_dev";
my $dbh        = DBI->connect( $dsn, '', '', { RaiseError => 1 }  );
$dbh->begin_work;

try {
  my $book = ReadData( "info-card.xls" );
  my $sheet = $book->[1];

  my %id_count;
  my @rows = Spreadsheet::Read::rows( $sheet );
  my $headers = shift @rows;
  my $max_header = @{ $headers } - 1;
  my $exact_matches = 0;
  my $duplicates = 0;
  my $rows_examined = 0;
  my $already_found = 0;
  my $updated = 0;

  for my $row ( @rows ) {
    $rows_examined++;
    my $info = {};

    for my $i ( 0 .. $max_header ) {
      my $key = $headers->[ $i ];
      my $value = $row->[ $i ] || '';
      $info->{ $key } = $value;
    }

    if ( $info->{ID} ) {
      my $id = $info->{ID};
      $already_found++;

      try {
        my $prepared = prepare_info( $dbh, $info );
        update_row( $dbh, $prepared );
        $updated++;
      } catch {
        warn "Unable to convert $info->{ID}: $_";
      };
    }
  }

  $exact_matches = grep { $id_count{$_} == 1 } keys %id_count;
  $duplicates = grep { $id_count{$_} > 1 } keys %id_count;

  say "$rows_examined rows";
  say "$already_found already found";
  say "$updated rows updated";
} catch {
  $dbh->rollback;
  die "Something terrible: $_";
};

$dbh->commit;

sub prepare_info {
  my ( $dbh, $info ) = @_;
  my $sth = $dbh->prepare("select * from clients where id = ?");
  $sth->execute( $info->{ID} );
  my $row = $sth->fetchrow_hashref;

  if ( my $oriented_on = $info->{"ORIENTATION DATE"} ) {
    $row->{oriented_on} = date_for( $oriented_on );
  }

  if ( my $full_name = full_name_for( $info ) ) {
    $row->{full_name} ||= $full_name;
  }

  if ( my $birthday = $info->{"DATE OF BIRTH"} ) {
    $row->{birthday} = date_for( $birthday );
  }

  if ( my $family_info = $info->{"CHILDREN'S NAME/DOB"} ) {
    $row->{family_info} = $family_info;
  }

  if ( my $emergency_contact = $info->{"EMERGENCY CONTACT"} ) {
    $row->{emergency_contact} = $emergency_contact;
  }

  if ( my $staying_at = $info->{'WHERE DO YOU STAY?'} ) {
    $row->{staying_at} = $staying_at;
  }

  if ( my $case_manager_info = $info->{"CASE MANAGER CONTACT INFORMATION"} ) {
    $row->{case_manager_info} = $case_manager_info;
  }

  if ( my $medical_info = $info->{'KNOWN ALLERGIES OR MEDICAL CONDITIONS'} ) {
    $row->{medical_info} = $medical_info;
  }

  if ( my $mailing_list_address = $info->{"MAILING LIST ADDRESS"} ) {
    $row->{mailing_list_address} = $mailing_list_address;
  }

  if ( my $email_address = $info->{"EMAIL ADDRESS"} ) {
    $row->{email_address} = $email_address;
  }

  if ( my $personal_goal = $info->{"PERSONAL GOAL"} ) {
    $row->{personal_goal} = $personal_goal;
  }

  if ( my $community_goal = $info->{"COMMUNITY GOAL"} ) {
    $row->{community_goal} = $community_goal;
  }

  if ( my $on_mailing_list = $info->{"WOULD YOU LIKE TO BE ADDED TO THE MAILING LIST?"} ) {
    $on_mailing_list = $on_mailing_list =~ /^[Yy]/ 
                    ? 1
                    : 0
                    ;
    $row->{on_mailing_list} = $on_mailing_list;
  }

  return $row;
}

sub date_for {
  my $excel_date = shift;
  DateTime::Format::Excel->parse_datetime( $excel_date )->iso8601();
}

sub full_name_for {
  my $info = shift;
  my $name = "";

  if ( my $first_name = $info->{"FIRST NAME"} ) {
    $name .= $first_name;
  }

  if ( my $last_name = $info->{"LAST  NAME"} ) {
    $name .= " $last_name";
  }

  $name =~ s/\s+/ /g;

  return $name;
}

sub update_row {
  my ( $dbh, $row ) = @_;
  $row->{last_edited_by_id} = 1;
  my $query =<<END_SQL
  update clients
  set
    oriented_on          = ?,
    full_name            = ?,
    birthday             = ?,
    family_info          = ?,
    emergency_contact    = ?,
    staying_at           = ?,
    case_manager_info    = ?,
    medical_info         = ?,
    on_mailing_list      = ?,
    mailing_list_address = ?,
    email_address        = ?,
    personal_goal        = ?,
    community_goal       = ?,
    last_edited_by_id    = 1,
    updated_at           = now()
  where id = ?
END_SQL
  ;

  my $sth = $dbh->prepare( $query )
    or die "Unable to prepare query: $dbh->errstr";
  $sth->bind_param( 1, $row->{oriented_on} );
  $sth->bind_param( 2, $row->{full_name} );
  $sth->bind_param( 3, $row->{birthday} );
  $sth->bind_param( 4, $row->{family_info} );
  $sth->bind_param( 5, $row->{emergency_contact} );
  $sth->bind_param( 6, $row->{staying_at} );
  $sth->bind_param( 7, $row->{case_manager_info} );
  $sth->bind_param( 8, $row->{medical_info} );
  $sth->bind_param( 9, $row->{on_mailing_list} );
  $sth->bind_param( 10, $row->{mailing_list_address} );
  $sth->bind_param( 11, $row->{email_address} );
  $sth->bind_param( 12, $row->{personal_goal} );
  $sth->bind_param( 13, $row->{community_goal} );
  $sth->bind_param( 14, $row->{id} );

  $sth->execute();
}

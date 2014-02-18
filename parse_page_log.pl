#!/usr/bin/perl

# Default PageLogFormat:
# printer user job-id date-time page-number num-copies job-billing job-originating-host-name job-name media sides
#
# Throw away everything after host-name because we don't care and it will
# break spliting on space due to space in print job names. If we really
# care in the future change the format in /etc/cups/cupsd.conf

use Modern::Perl;
use File::Slurp qw(read_file);
use List::MoreUtils qw(mesh);
use Time::Piece;
use DB_File;
use DBI;
use Data::Dumper;

my $SPACE           = qr{\s};
my $PAGE_LOG        = q{page_log};
my $ACCT_DB         = q{cups_acct.db};
my @HEADERS         = (qw(printer user job_id datetime tz_offset page_number num_copies job_billing host_name));
my $DATETIME_FORMAT = q{[%d/%b/%Y:%H:%M:%S};

my %results = ();
my $dbh = DBI->connect(qq{dbi:SQLite:dbname=$ACCT_DB},"","");

for my $line (read_file($PAGE_LOG)) {
  my @parts           = split($SPACE, $line);
  my @fields          = splice(@parts, 0, scalar(@HEADERS));
  my $result_ref      = {mesh @HEADERS, @fields};
  $result_ref->{time} = Time::Piece->strptime($result_ref->{datetime}, $DATETIME_FORMAT);

  delete $result_ref->{tz_offset};
  delete $result_ref->{datetime};
  delete $result_ref->{printer};

  push @{$results{$fields[0]}}, $result_ref;
}

print Dumper \%results;

#!/usr/bin/perl

# Default PageLogFormat:
# printer user job-id date-time page-number num-copies job-billing job-originating-host-name job-name media sides
#
# Throw away everything after host-name because we don't care and it will
# break spliting on space due to space in print job names. If we really
# care in the future change the format in /etc/cups/cupsd.conf

use FindBin qw($Bin);
use lib qq{$Bin/../lib}, qq{$Bin/../lib/perl5};

use Cups::DB;
use Cups::DB::Jobs;
use Cups::DB::Jobs::Manager;

use Modern::Perl;
use File::Slurp qw(read_file);
use List::MoreUtils qw(mesh);
use Time::Piece;
use Data::Dumper;

my $SPACE           = qr{\s};
my $PAGE_LOG        = qq{/var/log/cups/page_log};
my @HEADERS         = (qw(printer uniqname job_id datetime tz_offset page_number num_copies job_billing host_name));
my $DATETIME_FORMAT = q{[%d/%b/%Y:%H:%M:%S};

for my $line (read_file($PAGE_LOG)) {
  my @parts = split($SPACE, $line);
  my @fields = splice(@parts, 0, scalar(@HEADERS));
  my $job_ref = {mesh @HEADERS, @fields};

  next if $job_ref->{page_number} eq 'total';

  my $params = {
    printer     => $job_ref->{printer},
    uniqname    => $job_ref->{uniqname},
    job_id      => $job_ref->{job_id},
    page_number => $job_ref->{page_number},
    num_copies  => $job_ref->{num_copies},
    job_billing => $job_ref->{job_billing},
    host_name   => $job_ref->{host_name},
    printed_at  => Time::Piece->strptime($job_ref->{datetime}, $DATETIME_FORMAT)->epoch,
  };

  my $job = Cups::DB::Jobs::Manager->find_or_create($params);
}

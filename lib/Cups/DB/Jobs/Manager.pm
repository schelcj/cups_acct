package Cups::DB::Jobs::Manager;

use Rose::DB::Object::Manager;
use base qw(Rose::DB::Object::Manager);

sub object_class {
  return 'Cups::DB::Jobs';
}

__PACKAGE__->make_manager_methods('jobs');

sub find_or_create {
  my ($self, $params) = @_;

  my $record = undef;
  my $query  = [
    printer  => $params->{printer},
    uniqname => $params->{uniqname},
    job_id   => $params->{job_id},
  ];

  if (__PACKAGE__->get_jobs_count(query => $query, limit => 1)) {
    $record = __PACKAGE__->get_jobs(query => $query)->[0];
  } else {
    $record = __PACKAGE__->new($params);
    $record->save;
  }

  return $record;
}

1;

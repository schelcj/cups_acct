package Cups::DB::Jobs;

use Cups::DB;
use base qw(Rose::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'jobs',
  columns => [
    id          => {type => 'serial',   primary_key => 1},
    printer     => {type => 'text',     not_null    => 1},
    uniqname    => {type => 'text',     not_null    => 1},
    job_id      => {type => 'integer',  not_null    => 1},
    num_copies  => {type => 'integer',  not_null    => 1},
    page_number => {type => 'integer',  not_null    => 1},
    job_billing => {type => 'integer',  not_null    => 1},
    host_name   => {type => 'text',     not_null    => 1},
    printed_at  => {type => 'datetime', not_null    => 1},
  ],
  unique_key => ['printer', 'uniqname', 'job_id'],
);

sub init_db {
  return Cups::DB->new();
}

1;

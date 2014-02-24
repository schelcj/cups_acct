package Cups::DB;

use Rose::DB;
use base qw(Rose::DB);

__PACKAGE__->use_private_registry;

__PACKAGE__->register_db(
  domain   => __PACKAGE__->default_domain,
  type     => __PACKAGE__->default_type,
  driver   => 'sqlite',
  database => q(/var/cache/cups/acct.db),
);

1;

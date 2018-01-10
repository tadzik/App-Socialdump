package App::Socialdump::Schema::Result::Tweet;
use 5.024;
use experimental qw(signatures);
use strict;
use warnings;
use base 'DBIx::Class::Core';

no warnings 'experimental::signatures';

__PACKAGE__->table("tweets");
__PACKAGE__->add_columns(
    id => {
        data_type         => "integer",
        is_auto_increment => 0,
        is_nullable       => 0
    },
    jsondata => {
        data_type   => "text",
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key("id");

1;

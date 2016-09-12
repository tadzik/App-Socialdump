package App::Socialdump::Person;
use 5.018;
use strict;
use warnings;
use Moo;

has [qw/displayname
        handle
        profile_url
        avatar_url/] => (is => 'ro');

sub from_twitter {
    my ($class, $json) = @_;
    return $class->new(
        displayname => $json->{name},
        handle      => $json->{screen_name},
        profile_url => "https://twitter.com/" . $json->{screen_name},
        avatar_url  => $json->{profile_image_url},
    );
}

1;

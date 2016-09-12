package App::Socialdump::Status;
use App::Socialdump::Person;
use DateTime::Format::DateParse;
use 5.018;
use strict;
use warnings;
use Moo;

has [qw/author
        has_oc
        text
        created_at
        retweeted_status
        quoted_status
        media
        external_url/] => (is => 'ro');

sub from_twitter {
    my ($class, $json) = @_;
    my $retweet = $json->{retweeted_status} ? $class->from_twitter($json->{retweeted_status}) : undef;
    my $quoted  = $json->{quoted_status}    ? $class->from_twitter($json->{quoted_status})    : undef;
    my $author  = App::Socialdump::Person->from_twitter($json->{user});
    my $has_oc = 1;
    if ($json->{text} =~ /^RT @\w+:/) {
        $has_oc = 0;
    }
    my $at = DateTime::Format::DateParse->parse_datetime(
        $json->{created_at},
    );
    return $class->new(
        author           => $author,
        has_oc           => $has_oc,
        text             => $json->{text},
        created_at       => $at,
        retweeted_status => $retweet,
        quoted_status    => $quoted,
        media            => $json->{entities}{media},
        external_url     => $author->profile_url . "/status/" . $json->{id},
    );
}

sub to_string {
    my ($self) = shift;
    return sprintf "@%s: %s", $self->author->handle, $self->text;
}

1;

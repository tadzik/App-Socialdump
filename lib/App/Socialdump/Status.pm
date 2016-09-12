package App::Socialdump::Status;
use App::Socialdump::Person;
use DateTime::Format::DateParse;
use 5.018;
use strict;
use warnings;
use Moo;

has [qw/author
        oc
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
    my $oc = 1;
    if ($json->{text} =~ /^RT @\w+:/) {
        $oc = 0;
    }
    my $at = DateTime::Format::DateParse->parse_datetime(
        $json->{created_at},
    );
    return $class->new(
        author           => $author,
        oc               => $oc,
        text             => $json->{text},
        created_at       => $at,
        retweeted_status => $retweet,
        quoted_status    => $quoted,
        media            => $json->{entities}{media},
        external_url     => $author->profile_url . "/status/" . $json->{id},
    );
}

1;

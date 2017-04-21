package App::Socialdump::Status;
use App::Socialdump::Person;
use DateTime::Format::DateParse;
use 5.024;
use experimental qw(signatures postderef);
use strict;
use warnings;
use Moo;

has [qw/id
        in_reply_to_id
        author
        has_oc
        text
        html_text
        created_at
        retweeted_status
        quoted_status
        media
        external_url/] => (is => 'ro');

sub from_twitter($class, $json) {
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
        id               => $json->{id},
        in_reply_to_id   => $json->{in_reply_to_status_id},
        author           => $author,
        has_oc           => $has_oc,
        text             => $json->{text},
        html_text        => enrich_text($json),
        created_at       => $at,
        retweeted_status => $retweet,
        quoted_status    => $quoted,
        media            => $json->{entities}{media},
        external_url     => $author->profile_url . "/status/" . $json->{id},
    );
}

sub enrich_text($tweet) {
    my @entities;
    for my $url ($tweet->{entities}{urls}->@*) {
        push @entities, {
            from => $url->{indices}[0],
            to   => $url->{indices}[1],
            url  => $url->{expanded_url},
            text => $url->{display_url},
        };
    }
    for my $user ($tweet->{entities}{user_mentions}->@*) {
        push @entities, {
            from => $user->{indices}[0],
            to   => $user->{indices}[1],
            url  => "https://twitter.com/" . $user->{screen_name},
            text => '@' . $user->{screen_name},
        };
    }
    for my $hashtag ($tweet->{entities}{hashtags}->@*) {
        push @entities, {
            from => $hashtag->{indices}[0],
            to   => $hashtag->{indices}[1],
            url  => "https://twitter.com/hashtag/" . $hashtag->{text},
            text => '#' . $hashtag->{text},
        };
    }

    @entities = sort { $b->{from} <=> $a->{from} } @entities;

    my $text = $tweet->{text};
    for my $ent (@entities) {
        substr $text, $ent->{from}, $ent->{to} - $ent->{from},
               "<a href=\"$ent->{url}\">$ent->{text}</a>";
    }

    $text =~ s{\n}{<br />}g;

    return $text;
}

sub to_string($self) {
    return sprintf "@%s: %s", $self->author->handle, $self->text;
}

1;

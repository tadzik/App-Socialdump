package App::Socialdump;
use App::Socialdump::Status;
use App::Socialdump::Monologue;
use App::Socialdump::Conversation;
use 5.018;
use strict;
use warnings;
use Twitter::API;
use Dancer2;
use Dancer2::Plugin::DBIC;
use DateTime;
use DateTime::Format::SQLite;

use Data::Dumper;
our $VERSION = '0.1';

my $nt = Twitter::API->new_with_traits(
    traits => [qw/ApiMethods Migration/],
    consumer_key => config->{twitter}{consumer_key},
    consumer_secret => config->{twitter}{consumer_secret},
    access_token => config->{twitter}{access_token},
    access_token_secret => config->{twitter}{access_token_secret},
    ssl => 1,
);

sub check_for_new_tweets {
    my $maxid = resultset('Tweet')->get_column('id')->max;

    #my $last_update = DateTime::Format::SQLite->parse_datetime($row->{last_update});
    #my $now = DateTime->now;
    #my $age = $now - $last_update;
    #if ($age->minutes >= 1) {
    my $tweets;
    if ($maxid) {
        $tweets = $nt->get('statuses/home_timeline', { since_id => $maxid, tweet_mode => 'extended' });
    } else {
        $tweets = $nt->get('statuses/home_timeline', { tweet_mode => 'extended' });
    }
    for (@$tweets) {
        resultset('Tweet')->create({
            id       => $_->{id},
            jsondata => to_json($_),
        });
    }
}

sub get_tweets {
    return map {
        App::Socialdump::Status->from_twitter(from_json($_->jsondata))
    } resultset('Tweet')->search;
}

sub get_threads {
    check_for_new_tweets();
    my @statuses = get_tweets();

    my %id_to_statuses;
    for (@statuses) {
        $id_to_statuses{$_->id} = $_;
    }

    my @conversations;
    my %statuses_in_conversations;
    for my $status (reverse @statuses) {
        # skip if not a part of any conversation
        next unless $status->in_reply_to_id;
        # see if we already have a conversation with what this tweet is replying to
        if (my $convo = $statuses_in_conversations{$status->in_reply_to_id}) {
            $convo->add_status($status);
            $statuses_in_conversations{$status->id} = $convo;
        }
        # if not, see if we even know what it's a reply to
        elsif (my $parent = $id_to_statuses{$status->in_reply_to_id}) {
            # they form a conversation, create a new one and add them both
            my $convo = App::Socialdump::Conversation->new();
            $convo->add_status($parent);
            $convo->add_status($status);
            $statuses_in_conversations{$parent->id} = $convo;
            $statuses_in_conversations{$status->id} = $convo;
            push @conversations, $convo;
        }
    }
    # "unwrap" conversations that turned out to only have one participant:
    # those are mere monologues, and we deal with them later
    @conversations = grep {
        if (scalar(@{$_->participants}) > 1) {
            1;
        } else {
            for my $status (@{$_->statuses}) {
                delete $statuses_in_conversations{$status->id}
            }
            0;
        }
    } @conversations;

    # filter out what we deem conversations from statuses
    @statuses = grep { not $statuses_in_conversations{$_->id} } @statuses;

    # merge remaining statuses to aggregate monologues
    my @monologues;
    my $last_author = $statuses[0]->author;
    my $current_set = [];
    for (@statuses) {
        if ($_->author->handle ne $last_author->handle) {
            push @monologues, App::Socialdump::Monologue->new(
                author   => $last_author,
                statuses => $current_set,
            );
            $current_set = [];
        }
        unshift @$current_set, $_;
        $last_author = $_->author;
    }

    return reverse sort { DateTime->compare($a->highwater, $b->highwater) } (@conversations, @monologues);
}

get '/' => sub {
    my @threads = get_threads();
    template 'index', { threads => \@threads };
};

true;

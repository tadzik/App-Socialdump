package App::Socialdump;
use App::Socialdump::Status;
use App::Socialdump::Monologue;
use App::Socialdump::Conversation;
use 5.018;
use strict;
use warnings;
#use Net::Twitter;
use Dancer2;
use File::Slurp;
use DateTime;

our $VERSION = '0.1';

#my $nt = Net::Twitter->new(
#    traits => [qw/API::RESTv1_1/],
#    consumer_key => config->{twitter}{consumer_key},
#    consumer_secret => config->{twitter}{consumer_secret},
#    access_token => config->{twitter}{access_token},
#    access_token_secret => config->{twitter}{access_token_secret},
#    ssl => 1,
#);

get '/' => sub {
    #my $raw = $nt->home_timeline({ count => 100 });
    #write_file('100_tweets.json', to_json($raw));
    my $raw = from_json read_file('100_tweets.json');
    my @statuses = map { App::Socialdump::Status->from_twitter($_) } @$raw;

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

    my @threads = reverse sort { DateTime->compare($a->highwater, $b->highwater) } (@conversations, @monologues);

    template 'index', { threads => \@threads };
};

true;

package App::Socialdump;
use App::Socialdump::Status;
use App::Socialdump::Monologue;
use 5.018;
use strict;
use warnings;
use Net::Twitter;
use Dancer2;
use File::Slurp;

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

    # merge statuses to aggregate monologues
    my @status_sets;
    my $last_author = $statuses[0]->author;
    my $current_set = [];
    for (@statuses) {
        if ($_->author->handle ne $last_author->handle) {
            push @status_sets, App::Socialdump::Monologue->new(
                author   => $last_author,
                statuses => $current_set,
            );
            $current_set = [];
        }
        unshift @$current_set, $_;
        $last_author = $_->author;
    }

    template 'index', { monologues => \@status_sets };
};

true;

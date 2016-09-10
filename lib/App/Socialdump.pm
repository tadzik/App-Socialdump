package App::Socialdump;
#use Net::Twitter;
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
    #my $statuses = $nt->home_timeline();
    my $statuses = from_json read_file('tweets.json');
    template 'index', { statuses => $statuses };
};

true;

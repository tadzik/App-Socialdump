package App::Socialdump::Monologue;
use 5.018;
use strict;
use warnings;
use Moo;

has [qw/author
        statuses/] => (is => 'ro');

sub length {
    my $self = shift;
    return scalar @{$self->statuses};
}

sub has_oc {
    my $self = shift;
    for (@{$self->statuses}) {
        if ($_->has_oc) {
            return 1;
        }
    }
    return 0;
}

sub highwater {
    my $self = shift;
    my $last = scalar(@{$self->statuses}) - 1;
    return $self->statuses->[$last]->created_at;
}

1;

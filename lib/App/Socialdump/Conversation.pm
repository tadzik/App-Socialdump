package App::Socialdump::Conversation;
use 5.018;
use strict;
use warnings;
use Moo;

has [qw/ids
        authors
        statuses/] => (is => 'ro');

sub BUILD {
    my $self = shift;
    $self->{ids} = {};
    $self->{authors} = {};
    $self->{statuses} = [];
}

sub add_status {
    my ($self, $status) = @_;
    $self->ids->{$status->id} = 1;
    $self->authors->{$status->author->handle} = $status->author;
    push @{$self->statuses}, $status;
}

sub participants {
    my $self = shift;
    return [values %{$self->authors}];
}

sub highwater {
    my $self = shift;
    my $last = scalar(@{$self->statuses}) - 1;
    return $self->statuses->[$last]->created_at;
}

sub length {
    my $self = shift;
    return scalar(@{$self->statuses});
}

sub has_oc {
    return 1;
}

sub to_string {
    my $self = shift;
    my $ret = sprintf "Conversation between %s:\n", join(", ", map { $_->displayname } values %{$self->authors});
    for (@{$self->statuses}) {
        $ret .= sprintf "\t%15s: %s\n", $_->author->displayname, $_->text;
    }
    return $ret;
}

1;

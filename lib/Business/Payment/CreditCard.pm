package Business::Payment::CreditCard;

use Moose;

has 'number' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'expiration' => (
    is       => 'rw',
    isa      => 'DateTime',
    required => 1
);

sub expdate {
    shift->expiration->strftime('%m%y');
}

no Moose;
__PACKAGE__->meta->make_immutable;

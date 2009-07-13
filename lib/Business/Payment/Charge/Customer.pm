package Business::Payment::Charge::Customer;

use Moose::Role;

has 'first_name' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'last_name' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'address' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

no Moose::Role;
1;


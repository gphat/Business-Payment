package Business::Payment::Types;
use MooseX::Types -declare => [qw(Currency)];

use MooseX::Types::Moose qw/Num/;

use Math::Currency;

class_type 'Math::Currency';

coerce 'Math::Currency',
    from Num,
    via { Math::Currency->new(@_) };


1;

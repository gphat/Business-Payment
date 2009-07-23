package Business::Payment::Types;
use MooseX::Types;

use MooseX::Types::Moose qw/Num Str/;

use Math::Currency;
use DateTime;

class_type 'DateTime';
class_type 'Math::Currency';

coerce 'Math::Currency',
    from Num,
    via { Math::Currency->new(@_) };

coerce 'DateTime',
    from Str,
    via {
        my ($date) = @_;
        my ($m, $y); # Predeclare M and Y that we will use for DT
        # Catch things in the form of MM/YY
        if($date =~ /\//) {
            ($m, $y) = split('\/', $date);
        } else {
            die 'Expiration date must be in the form of MM/YY or MM/YYYY';
        }

        # Build a 4 digit year by prepending the first two digits of the
        # current year.
        if(length($y) == 2) {
            my $now = DateTime->now;
            $y = substr($now->year, 0, 2).$y;
        }

        DateTime->new(month => $m, year => $y);
    };

1;

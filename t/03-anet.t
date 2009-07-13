use Test::More tests => 2;

use warnings;
use strict;

use Business::Payment;
use Business::Payment::Charge;
use Business::Payment::Processor::AuthorizeNet;

my $bp = Business::Payment->new(
    processor => Business::Payment::Processor::AuthorizeNet->new(
        server      => 'test.authorize.net',
        login       => 'f9zmKtPbQtD',
        password    => 'Vzx2n2Uk2TPanu3M'
    )
);

my $charge = $bp->charge( 
    amount => 10.00,
    first_name => 'Testy',
    last_name => 'McTestes',
    address   => '1234 Any St',
);
isa_ok($charge, 'Business::Payment::Charge', 'charge object');

my $result = $bp->handle($charge);
isa_ok($result, 'Business::Payment::Result', 'result class');


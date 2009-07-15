use Test::More tests => 3;

use warnings;
use strict;

use Data::Dump 'dump';
use DateTime;
use Business::Payment;
use Business::Payment::Charge;
use Business::Payment::CreditCard;
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
    credit_card => Business::Payment::CreditCard->new(
        number     => '4111111111111111',
        expiration => DateTime->new( year => 2015, month => 10 )
    )
);
isa_ok($charge, 'Business::Payment::Charge', 'charge object');

my $result = $bp->handle($charge);
isa_ok($result, 'Business::Payment::Result', 'result class');
ok($result->success, 'all about getting that cash money');

diag(dump($result->extra));

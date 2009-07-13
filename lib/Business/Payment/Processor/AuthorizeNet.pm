package Business::Payment::Processor::AuthorizeNet;

use Moose;
use Carp;

use Business::Payment::Result;

with 'Business::Payment::Processor',
     'Business::Payment::SSL';

has 'charge_roles' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [
        qw/Customer/
    ] }
);

has '+server' => (
    default => 'secure.authorize.net'
);

has '+path' => (
    default => '/gateway/transact.dll'
);

has 'login' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has 'password' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has 'email_customer' => (
    is          => 'rw',
    isa         => 'Bool',
    default     => 0
);

sub handle {
    my ( $self, $charge ) = @_;

    my $data = $self->_setup_request( $charge );
    #$self->request(
    #    { },
    #    { %data }
    #);

    return Business::Payment::Result->new(
        success => 0,
        error_code => -1,
        error_message => 'Failed on purpose!'
    );
}

sub _setup_request {
    my ( $self, $charge ) = @_;

    my %data = ();

    if ( $self->email_customer ) {
        $data{'x_Email_Customer'} = 'TRUE';
    }

    $charge->type eq 'VOID' ?
        $data{'x_Method'} = 'VOID' :
    $charge->type eq 'CREDIT' ?
        $data{'x_Method'} = 'CREDIT' :
    $charge->type eq 'CHARGE' ?
        $data{'x_Method'} = 'AUTH_CAPTURE' :
    $charge->type eq 'AUTH' ?
        $data{'x_Method'} = 'AUTH_ONLY' :
    $charge->type eq 'CAPTURE' ?
        $data{'x_Method'} = 'PRIOR_AUTH_CAPTURE' :
    # Unknown charge type, end it here
        croak "Unknown charge type";

    return \%data;
}


no Moose;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Business::Payment::Processor::AuthorizeNet - Authorize.NET Processor

=head1 SYNOPSIS

    use Business::Payment;

    my $bp = Business::Payment->new(
        processor => Business::Payment::Processor::Test::False->new
    );

    my $charge = $bp->charge(
        amount      => 10.00,
        first_name  => 'Test',
        last_name   => 'McTest',
        address     => '1234 Any St',
        city        => 'Some City',
        state       => 'CA',
        zip         => '92562'
    );

    my $result = $bp->handle($charge);

    print "Failed: ".$result->error_code.": ".$result->error_message."\n";

=head1 DESCRIPTION

Business::Payment::Processor::AuthorizeNet is a processor for collecting money
through the Authorize.Net payment gateway.

=head1 AUTHOR

J. Shirley, C<< <jshirley@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cold Hard Code, LLC, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

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

has 'delim_char' => (
    is => 'rw', isa => 'Str', required => 1, default => '|' 
);

has 'api_version' => ( 
    is => 'rw', isa => 'Str', required => 1, default => '3.1' 
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

sub prepare_data {
    my ( $self, $charge ) = @_;

    my %data = (
        x_login             => $self->login,
        x_password          => $self->password,
        x_version           => $self->api_version,
        x_delim_data        => "TRUE",
        x_delim_char        => $self->delim_char,
        x_relay_response    => "FALSE",

    );

    if ( $self->email_customer ) {
        $data{'x_Email_Customer'} = 'TRUE';
    }

    if ( defined $charge->credit_card ) {
        $data{x_method}   = 'CC';
        $data{x_card_num} = $charge->credit_card->number;
        $data{x_exp_date} = $charge->credit_card->expdate;
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

    $data{'x_amount'}      = $charge->amount;
    $data{'x_description'} = $charge->description;
    return \%data;
}

sub prepare_result {
    my ( $self, $page, $response ) = @_;

use Data::Dump 'dump';
warn "Page: " . dump($page);
warn "Response: " . dump($response);

    my $char = $self->delim_char;
    my @data = split( /\Q$char/, $page );
    my $index = 0;
    my %fields = 
        map { $_ => $data[$index++] }
        qw/ 
            code subcode reason reason_text authorization avs
            transaction_id invoice_number
            description amount method transaction_type
            customer_id first_name last_name company
            address city state zip country
            phone fax email 
            ship_to_first_name ship_to_last_name ship_to_first_company 
            ship_to_address ship_to_city ship_to_state ship_to_zip 
            ship_to_country
            tax duty freight tax_exempt po_number md5_hash
            card_code_response cardholder_auth
        /;

    my $r = Business::Payment::Result->new(
        success         => $fields{code} == 1,
        error_code      => $fields{reason},
        error_message   => $fields{reason_text},
        extra           => \%fields
    );

    return $r;
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

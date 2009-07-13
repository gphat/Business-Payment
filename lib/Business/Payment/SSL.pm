package Business::Payment::SSL;

use Moose::Role;

use namespace::autoclean;
use Net::SSLeay qw(make_headers make_form get_https post_https);

has 'server' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1
);

has 'port' => (
    is          => 'rw',
    isa         => 'Int',
    required    => 1,
    default     => 443
);

has 'path' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
    default     => '/'
);

has 'method' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
    default     => 'POST'
);

sub uri {
    my ( $self ) = @_;
    my $uri = URI->new( $self->server, 'https' );
    $uri->port( $self->port );
    $uri->path( $self->path );

    return $uri;
}

sub request { 
    my ( $self, $headers, $data ) = @_;

    my $method = uc($self->method) eq 'POST' ? 'post_https' : 'get_https';
    $headers = ref $headers eq 'HASH' ? make_headers(%$headers) : $headers;
    $data    = ref $data eq 'HASH' ? make_form(%$data) : $data;
    my ( $page, $response, %response_headers ) = 
        &{$method}( $self->server, $self->port, $self->path, $headers, $data );

    return $response;
}

no Moose::Role;
1;

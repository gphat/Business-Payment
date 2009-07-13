package Business::Payment::Processor;
use Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Business::Payment::Processor - Base Class for all Processors

=head1 SYNOPSIS

    package My::Processor;
    use Moose;
    
    extends 'Business::Payment::Processor';

    sub handle {
        
    }
    
    1;

=head1 DESCRIPTION

Business::Payment::Processor is the base class from which all Processors
should inherit.

=head1 AUTHOR

Cory G Watson, C<< <gphat@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cold Hard Code, LLC, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.



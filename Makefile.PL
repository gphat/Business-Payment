use inc::Module::Install;

name     'Business-Payment';
all_from 'lib/Business/Payment.pm';
author   'Cory G Watson <gphat@cpan.org>';
license  'perl';

build_requires 'Test::Exception';
build_requires 'Test::More';

requires    'DateTime';
requires    'Math::Currency'    => '0.46';
requires    'Moose'             => '0.87';
requires    'MooseX::Traits'    => '0.06'
requires    'MooseX::Types'     => '0.16';

WriteAll;


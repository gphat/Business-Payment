use inc::Module::Install;

name     'Business-Payment';
all_from 'lib/Business/Payment.pm';
author   'Cory G Watson <email>';
license  'perl';

build_requires 'Test::More';

requires    'Math::Currency'    => 0.46;
requires    'Moose'             => 0.87;
requires    'MooseX::Types'     => 0.16;

WriteAll;


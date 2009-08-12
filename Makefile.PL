use strict;
use warnings;
use inc::Module::Install;

name          ('Pod-Text-Ansi');
author_from   ('lib/Pod/Text/Ansi.pm');
abstract_from ('lib/Pod/Text/Ansi.pm');
version_from  ('lib/Pod/Text/Ansi.pm');
license       ('artistic');
requires      ('Pod::Text'       => '3.13');
requires      ('Term::ANSIColor' => '0');
test_requires ('Test::More'      => '0');
tests_recursive();
WriteAll();

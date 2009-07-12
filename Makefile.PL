use strict;
use warnings;
use inc::Module::Install;

name          ('Pod-Text-Ansi');
author_from   ('lib/Pod/Text/Ansi.pm');
abstract_from ('lib/Pod/Text/Ansi.pm');
version_from  ('lib/Pod/Text/Ansi.pm');
license       ('artistic');
requires      ('Pod::Text'       => '0');
requires      ('Term::ANSIColor' => '0');
tests_recursive();
WriteAll();

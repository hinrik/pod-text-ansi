package Pod::Text::Ansi;

use strict;
use warnings;
use Term::ANSIColor qw(colored);

use base 'Pod::Text';
our $VERSION = '0.02';

# wrap every line in Ansi color codes
sub color {
    my ($text, @codes) = @_;
    my @lines = split/\n/, $text;
    $_ = colored($_, @codes) for @lines;
    return join "\n", @lines;
}

# Make level one headings bold.
sub cmd_head1 {
    my ($self, $attrs, $text) = @_;
    $text =~ s/\s+$//;
    $self->SUPER::cmd_head1($attrs, color($text, 'bold'));
}

# Make level two headings bold.
sub cmd_head2 {
    my ($self, $attrs, $text) = @_;
    $text =~ s/\s+$//;
    $self->SUPER::cmd_head2($attrs, color($text, 'bold'));
}

sub cmd_verbatim {
    my ($self, $attrs, $text) = @_;
    $text = join("\n", map { color($_, 'yellow') } split(/\n/, $text));
    $self->SUPER::cmd_verbatim($attrs, color($text, 'yellow'));
}

# Fix the various formatting codes.
sub cmd_c { return color($_[2], 'yellow') }
sub cmd_b { return color($_[2], 'bold')   }
sub cmd_e { return color($_[2], 'green')  }
sub cmd_f { return color($_[2], 'cyan')   }
sub cmd_i { return color($_[2], 'green')  }
sub cmd_l { return color($_[2], 'blue')   }

# Output any included code in magenta
sub output_code {
    my ($self, $code) = @_;
    $code = color($code, 'magenta');
    $self->output ($code);
}

# We unfortunately have to override the wrapping code here, since the normal
# wrapping code gets really confused by all the escape sequences.
sub wrap {
    my $self = shift;
    local $_ = shift;
    my $output = '';
    my $spaces = ' ' x $$self{MARGIN};
    my $width = $$self{opt_width} - $$self{MARGIN};

    # We have to do $shortchar and $longchar in variables because the
    # construct ${char}{0,$width} didn't do the right thing until Perl 5.8.x.
    my $char = '(?:(?:\e\[[\d;]+m)*[^\n])';
    my $shortchar = $char . "{0,$width}";
    my $longchar = $char . "{$width}";
    while (length > $width) {
        if (s/^($shortchar)\s+// || s/^($longchar)//) {
            $output .= $spaces . $1 . "\n";
        } else {
            last;
        }
    }
    $output .= $spaces . $_;
    $output =~ s/\s+$/\n\n/;
    $output;
}

1;
__END__

=encoding UTF-8

=head1 NAME

Pod::Text::Ansi - Convert POD to ANSI-colored text

=head1 SYNOPSIS

    use Pod::Text::Ansi;
    my $parser = Pod::Text::Ansi->new (sentence => 0, width => 78);

    # Read POD from STDIN and write to STDOUT.
    $parser->parse_from_filehandle;

    # Read POD from file.pod and write to file.txt.
    $parser->parse_from_file ('file.pod', 'file.txt');

=head1 DESCRIPTION

Pod::Text::Ansi is a simple subclass of Pod::Text that highlights output
text using ANSI color escape sequences. Apart from the color, it in all
ways functions like Pod::Text. See L<Pod::Text> for details and available
options.

=head1 SEE ALSO

L<Pod::Text::Color|Pod::Text::Color>, L<Pod::Text|Pod::Text>,
L<Pod::Simple|Pod::Simple>

=head1 AUTHOR

Hinrik Örn Sigurðsson, L<hinrik.sig@gmail.com>

Based on L<Pod::Text::Color|Pod::Text::Color> by Russ Allbery
L<rra@stanford.edu>.

=head1 LICENSE AND COPYRIGHT

Copyright 1999, 2001, 2004, 2006 by Russ Allbery L<rra@stanford.edu>.

Copyright (c) 2009, Hinrik Örn Sigurðsson L<hinrik.sig@gmail.com>.

This program is free software; you may redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut

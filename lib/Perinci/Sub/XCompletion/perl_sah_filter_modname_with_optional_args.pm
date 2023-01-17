package Perinci::Sub::XCompletion::perl_sah_filter_modname_with_optional_args;

use strict;
use warnings;
use Log::ger;

# AUTHORITY
# DATE
# DIST
# VERSION

sub gen_completion {
    my %gcargs = @_;

    sub {
        no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict

        my %cargs = @_;

        my $word = $cargs{word};

        my ($word_mod, $word_eq, $word_modargs) = $word =~ /\A([^=]*)(=)?(.*?)\z/;
        #log_trace "TMP: word_mod, word_eq, word_modargs = %s, %s, %s", $word_mod, $word_eq, $word_modargs;

        unless ($word_eq) {
            require Complete::Module;
            my $modres = Complete::Module::complete_module(
                word => $word_mod,
                ns_prefix => "Data::Sah::Filter::perl::",
                recurse => 1,
            );

            # no module matches, we can't complete
            return [] unless @{ $modres->{words} };

            # multiple module matches, we also don't complete args, just the modules
            return $modres if @{ $modres->{words} } > 1;

            # normalize the module part
            $word_mod = ref $modres->{words}[0] eq 'HASH' ? $modres->{words}[0]{word} : $modres->{words}[0];
        }

        (my $psf_module = $word_mod) =~ s![/.]!::!g;

        my $module = "Data::Sah::Filter::perl::$psf_module";
        (my $module_pm = "$module.pm") =~ s!::!/!g;
        eval { require $module_pm; 1 };
        do { log_trace "Can't load module $module: $@. Skipped checking for arguments"; return [$word_mod] } if $@;

        my $sub = "$module\::meta";
        do { log_trace "Module $module does not have meta(), thus no arguments defined"; return [$word_mod] } unless defined &{$sub};

        my $meta = &{$sub};
        do { log_trace "Meta for filter does not define arguments"; return [$word_mod] } unless $meta->{args} && keys(%{ $meta->{args} });

        my @fargs = sort keys %{ $meta->{args} };
        my @fargs_summaries = map { $meta->{args}{$_}{summary} } @fargs;
        require Complete::Util;
        my $ccsp_res = Complete::Util::complete_comma_sep_pair(
            word => $word_modargs,
            keys => \@fargs,
            keys_summaries => \@fargs_summaries,
            complete_value => sub {
                my %cvargs = @_;
                my $key = $cvargs{key};
                return [] unless $meta->{args}{$key};
                return [] unless $meta->{args}{$key}{schema};

                require Perinci::Sub::Complete;
                Perinci::Sub::Complete::complete_from_schema(
                    word => $cvargs{word},
                    schema => $meta->{args}{$key}{schema},
                );
            },
        );
        Complete::Util::modify_answer(answer => $ccsp_res, prefix => "$word_mod=");
    },
}

1;
# ABSTRACT: Generate completion for perl Sah filter module name with optional arguments

=head1 SYNOPSIS

To use, put this in your L<Sah> schema's C<x.completion> attribute:

 'x.completion' => ['perl_sah_filter_modname_with_optional_args'],

=cut

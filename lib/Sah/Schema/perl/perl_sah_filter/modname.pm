package Sah::Schema::perl::perl_sah_filter::modname;

use strict;

use Sah::PSchema 'get_schema';
use Sah::PSchema::perl::modname; # not yet detected automatically by a dzil plugin

# AUTHORITY
# DATE
# DIST
# VERSION

our $schema = get_schema(
    'perl::modname',
    {ns_prefix=>'Data::Sah::Filter::perl', complete_recurse=>1},
    {
        summary => 'Perl module in the Data::Sah::Filter::perl::* namespace, without the namespace prefix, e.g. "Phone::format"',
    }
);

1;
# ABSTRACT:

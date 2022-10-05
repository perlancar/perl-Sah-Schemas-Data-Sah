package Sah::Schema::perl::perl_sah_filter::modname_with_optional_args;

use strict;

use Sah::PSchema 'get_schema';
use Sah::PSchema::perl::modname_with_optional_args; # not yet detected automatically by a dzil plugin

# AUTHORITY
# DATE
# DIST
# VERSION

our $schema = get_schema(
    'perl::modname_with_optional_args',
    {ns_prefix=>'Data::Sah::Filter::perl', complete_recurse=>1},
    {
        summary => 'Perl module in the Data::Sah::Filter::perl::* namespace, without the namespace prefix, with optional args e.g. "PhysicalQuantity::convert_unit=to,kg"',
    }
);

1;
# ABSTRACT:

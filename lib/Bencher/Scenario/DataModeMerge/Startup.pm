package Bencher::Scenario::DataModeMerge::Startup;

# DATE
# VERSION

our $scenario = {
    summary => 'Benchmark module startup overhead of Data::ModeMerge',

    module_startup => 1,

    participants => [
        {module=>'Data::ModeMerge'},
    ],
};

1;
# ABSTRACT:

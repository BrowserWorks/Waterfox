# NOTE: Derived from lib/Getopt/Long.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Getopt::Long;

#line 1020 "lib/Getopt/Long.pm (autosplit into lib/auto/Getopt/Long/Croak.al)"
# To prevent Carp from being loaded unnecessarily.
sub Croak (@) {
    require 'Carp.pm';
    $Carp::CarpLevel = 1;
    Carp::croak(@_);
};

################ Documentation ################


# Local Variables:
# eval: (load-file "pod.el")
# End:
1;
# end of Getopt::Long::Croak

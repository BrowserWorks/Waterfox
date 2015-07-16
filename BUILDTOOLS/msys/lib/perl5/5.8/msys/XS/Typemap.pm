package XS::Typemap;

=head1 NAME

XS::Typemap - module to test the XS typemaps distributed with perl

=head1 SYNOPSIS

  use XS::Typemap;

  $output = T_IV( $input );
  $output = T_PV( $input );
  @output = T_ARRAY( @input );

=head1 DESCRIPTION

This module is used to test that the XS typemaps distributed
with perl are working as advertised. A function is available
for each typemap definition (eventually). In general each function
takes a variable, processes it through the OUTPUT typemap and then
returns it using the INPUT typemap.

A test script can then compare the input and output to make sure they
are the expected values. When only an input or output function is
provided the function will be named after the typemap entry and have
either '_IN' or '_OUT' appended.

All the functions are exported. There is no reason not to do this since
the entire purpose is for testing Perl. Namespace pollution will be limited
to the test script.

=cut

use base qw/ DynaLoader Exporter /;


use vars qw/ $VERSION @EXPORT /;

$VERSION = '0.02';

@EXPORT = (qw/
	   T_SV
	   T_SVREF
	   T_AVREF
	   T_HVREF
	   T_CVREF
	   T_SYSRET_fail T_SYSRET_pass
	   T_UV
	   T_IV
	   T_INT
           T_ENUM
           T_BOOL
           T_U_INT
           T_SHORT
           T_U_SHORT
           T_LONG
           T_U_LONG
           T_CHAR
           T_U_CHAR
           T_FLOAT
           T_NV
	   T_DOUBLE
	   T_PV
	   T_PTR_IN T_PTR_OUT
	   T_PTRREF_IN T_PTRREF_OUT
	   T_REF_IV_REF
	   T_REF_IV_PTR_IN T_REF_IV_PTR_OUT
	   T_PTROBJ_IN T_PTROBJ_OUT
	   T_OPAQUE_IN T_OPAQUE_OUT T_OPAQUE_array
	   T_OPAQUEPTR_IN T_OPAQUEPTR_OUT T_OPAQUEPTR_OUT_short
           T_OPAQUEPTR_IN_struct T_OPAQUEPTR_OUT_struct
	   T_ARRAY
	   T_STDIO_open T_STDIO_close T_STDIO_print
	   /);


bootstrap XS::Typemap;

=head1 NOTES

This module is for testing only and should not normally be installed.

=head1 AUTHOR

Tim Jenness E<lt>t.jenness@jach.hawaii.eduE<gt>

Copyright (C) 2001 Tim Jenness All Rights Reserved.  This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut


1;


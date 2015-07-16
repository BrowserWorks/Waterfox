package Archive::Zip::MemberRead;

# Copyright (c) 2002 Sreeji K. Das. All rights reserved.  This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

=head1 NAME

Archive::Zip::MemberRead - A wrapper that lets you read Zip archive members as if they were files.

=cut

=head1 SYNOPSIS

  use Archive::Zip;
  use Archive::Zip::MemberRead;
  $zip = new Archive::Zip("file.zip");
  $fh  = new Archive::Zip::MemberRead($zip, "subdir/abc.txt");
  while (defined($line = $fh->getline()))
  {
      print $fh->input_line_number . "#: $line\n";
  }

  $read = $fh->read($buffer, 32*1024);
  print "Read $read bytes as :$buffer:\n";

=head1 DESCRIPTION

The Archive::Zip::MemberRead module lets you read Zip archive member data
just like you read data from files.

=head1 METHODS

=over 4

=cut

use strict;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

use vars qw{$VERSION};

BEGIN {
    $VERSION = '1.20';
    $VERSION = eval $VERSION;
}

=item Archive::Zip::Member::readFileHandle()

You can get a C<Archive::Zip::MemberRead> from an archive member by
calling C<readFileHandle()>:

  my $member = $zip->memberNamed('abc/def.c');
  my $fh = $member->readFileHandle();
  while (defined($line = $fh->getline()))
  {
	  # ...
  }
  $fh->close();

=cut

sub Archive::Zip::Member::readFileHandle {
    return Archive::Zip::MemberRead->new( shift() );
}

=item Archive::Zip::MemberRead->new($zip, $fileName)

=item Archive::Zip::MemberRead->new($zip, $member)

=item Archive::Zip::MemberRead->new($member)

Construct a new Archive::Zip::MemberRead on the specified member.

  my $fh = Archive::Zip::MemberRead->new($zip, 'fred.c')

=cut

sub new {
    my ( $class, $zip, $file ) = @_;
    my ( $self, $member );

    if ( $zip && $file )    # zip and filename, or zip and member
    {
        $member = ref($file) ? $file : $zip->memberNamed($file);
    }
    elsif ( $zip && !$file && ref($zip) )    # just member
    {
        $member = $zip;
    }
    else {
        die(
'Archive::Zip::MemberRead::new needs a zip and filename, zip and member, or member'
        );
    }

    $self = {};
    bless( $self, $class );
    $self->set_member($member);
    return $self;
}

sub set_member {
    my ( $self, $member ) = @_;

    $self->{member} = $member;
    $self->set_compression(COMPRESSION_STORED);
    $self->rewind();
}

sub set_compression {
    my ( $self, $compression ) = @_;
    $self->{member}->desiredCompressionMethod($compression) if $self->{member};
}

=item rewind()

Rewinds an C<Archive::Zip::MemberRead> so that you can read from it again
starting at the beginning.

=cut

sub rewind {
    my $self = shift;

    $self->_reset_vars();
    $self->{member}->rewindData() if $self->{member};
}

sub _reset_vars {
    my $self = shift;
    $self->{lines}   = [];
    $self->{partial} = 0;
    $self->{line_no} = 0;
}

=item input_line_number()

Returns the current line number, but only if you're using C<getline()>.
Using C<read()> will not update the line number.

=cut

sub input_line_number {
    my $self = shift;
    return $self->{line_no};
}

=item close()

Closes the given file handle.

=cut

sub close {
    my $self = shift;

    $self->_reset_vars();
    $self->{member}->endRead();
}

=item buffer_size([ $size ])

Gets or sets the buffer size used for reads.
Default is the chunk size used by Archive::Zip.

=cut

sub buffer_size {
    my ( $self, $size ) = @_;

    if ( !$size ) {
        return $self->{chunkSize} || Archive::Zip::chunkSize();
    }
    else {
        $self->{chunkSize} = $size;
    }
}

=item getline()

Returns the next line from the currently open member.
Makes sense only for text files.
A read error is considered fatal enough to die.
Returns undef on eof. All subsequent calls would return undef,
unless a rewind() is called.
Note: The line returned has the newline removed.

=cut

# $self->{partial} flags whether the last line in the buffer is partial or not.
# A line is treated as partial if it does not ends with \n
sub getline {
    my $self = shift;
    my ( $temp, $status, $size, $buffer, @lines );

    $status = AZ_OK;
    $size   = $self->buffer_size();
    $temp   = \$status;
    while ( $$temp !~ /\n/ && $status != AZ_STREAM_END ) {
        ( $temp, $status ) = $self->{member}->readChunk($size);
        if ( $status != AZ_OK && $status != AZ_STREAM_END ) {
            die "ERROR: Error reading chunk from archive - $status\n";
        }

        $buffer .= $$temp;
    }

    @lines = split( /\n/, $buffer );
    $self->{line_no}++;
    if ( $#lines == -1 ) {
        return ( $#{ $self->{lines} } == -1 )
          ? undef
          : shift( @{ $self->{lines} } );
    }

    $self->{lines}->[ $#{ $self->{lines} } ] .= shift(@lines)
      if $self->{partial};

    splice( @{ $self->{lines} }, @{ $self->{lines} }, 0, @lines );
    $self->{partial} = !( $buffer =~ /\n$/ );
    return shift( @{ $self->{lines} } );
}

=item read($buffer, $num_bytes_to_read)

Simulates a normal C<read()> system call.
Returns the no. of bytes read. C<undef> on error, 0 on eof, I<e.g.>:

  $fh = new Archive::Zip::MemberRead($zip, "sreeji/secrets.bin");
  while (1)
  {
    $read = $fh->read($buffer, 1024);
    die "FATAL ERROR reading my secrets !\n" if (!defined($read));
    last if (!$read);
    # Do processing.
    ....
   }

=cut

#
# All these $_ are required to emulate read().
#
sub read {
    my $self = $_[0];
    my $size = $_[2];
    my ( $temp, $status, $ret );

    ( $temp, $status ) = $self->{member}->readChunk($size);
    if ( $status != AZ_OK && $status != AZ_STREAM_END ) {
        $_[1] = undef;
        $ret = undef;
    }
    else {
        $_[1] = $$temp;
        $ret = length($$temp);
    }
    return $ret;
}

1;

=back

=head1 AUTHOR

Sreeji K. Das, <sreeji_k@yahoo.com>
See L<Archive::Zip> by Ned Konz without which this module does not make
any sense! 

Minor mods by Ned Konz.

=head1 COPYRIGHT

Copyright (c) 2002 Sreeji K. Das. All rights reserved.  This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut

package ExtUtils::CBuilder::Platform::VMS;

use strict;
use ExtUtils::CBuilder::Base;

use vars qw($VERSION @ISA);
$VERSION = '0.12';
@ISA = qw(ExtUtils::CBuilder::Base);

sub need_prelink { 0 }

sub arg_defines {
  my ($self, %args) = @_;

  s/"/""/g foreach values %args;

  my @config_defines;

  # VMS can only have one define qualifier; add the one from config, if any.
  if ($self->{config}{ccflags} =~ s{/  def[^=]+  =+  \(?  ([^\/\)]*)  } {}ix) {
    push @config_defines, $1;
  }

  return '' unless keys(%args) || @config_defines;

  return ('/define=(' 
          . join(',', 
		 @config_defines,
                 map "\"$_" . ( length($args{$_}) ? "=$args{$_}" : '') . "\"", 
                     keys %args) 
          . ')');
}

sub arg_include_dirs {
  my ($self, @dirs) = @_;

  # VMS can only have one include list, add the one from config.
  if ($self->{config}{ccflags} =~ s{/inc[^=]+(?:=)+(?:\()?([^\/\)]*)} {}i) {
    unshift @dirs, $1;
  }
  return unless @dirs;

  return ('/include=(' . join(',', @dirs) . ')');
}

sub _do_link {
  my ($self, $type, %args) = @_;
  
  my $objects = delete $args{objects};
  $objects = [$objects] unless ref $objects;
  
  # VMS has two option files, the external symbol, and to pull in PerlShr
  if ($args{lddl}) {
    my @temp_files =
      $self->prelink(%args, dl_name => $args{module_name});

    $objects->[-1] .= ',';

    # If creating a loadable library, the link option file is needed.
    push @$objects, 'sys$disk:[]' . $temp_files[0] . '/opt,';

    # VMS always needs the option file for the Perl shared image.
    push @$objects, $self->perl_inc() . 'PerlShr.Opt/opt';
  }

  return $self->SUPER::_do_link($type, %args, objects => $objects);
}

sub arg_nolink { return; }

sub arg_object_file {
  my ($self, $file) = @_;
  return "/obj=$file";
}

sub arg_exec_file {
  my ($self, $file) = @_;
  return ("/exe=$file");
}

sub arg_share_object_file {
  my ($self, $file) = @_;
  return ("$self->{config}{lddlflags}=$file");
}


sub lib_file {
  my ($self, $dl_file) = @_;
  $dl_file =~ s/\.[^.]+$//;
  $dl_file =~ tr/"//d;
  $dl_file = $dl_file .= '.' . $self->{config}{dlext};

  # Need to create with the same name as DynaLoader will load with.
  if (defined &DynaLoader::mod2fname) {
    my ($dev,$dir,$file) = File::Spec->splitpath($dl_file);
    $file = DynaLoader::mod2fname([$file]);
    $dl_file = File::Spec->catpath($dev,$dir,$file);
  }
  return $dl_file;
}

1;

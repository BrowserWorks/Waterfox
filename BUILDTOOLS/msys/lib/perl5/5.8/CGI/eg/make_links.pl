#!/usr/local/bin/perl

# this is just a utility for creating symlinks from *.txt to *.cgi
# for documentation purposes.
foreach (<*.cgi>) {
    ($target=$_)=~s/cgi$/txt/;
    symlink $_,$target
}

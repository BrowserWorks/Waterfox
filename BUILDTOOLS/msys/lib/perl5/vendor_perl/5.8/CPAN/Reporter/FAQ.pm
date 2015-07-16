package CPAN::Reporter::FAQ
# Not really a .pm file, but holds wikidoc which will be
# turned into .pod by the Build.PL
$VERSION = "0.44";
use strict; # make CPANTS happy
1;
__END__

=begin wikidoc

= NAME

CPAN::Reporter::FAQ - Answers and tips for using CPAN::Reporter

= VERSION

This documentation refers to version %%VERSION%%

= REPORT GRADES

== Why did I receive an NA report?  The test failed because of a missing prerequisite!

An NA report indicates missing prerequisites (and may eventually
indicate unsupported platforms).  As of version 0.36, CPAN::Reporter
defaults to not sending NA reports.  Earlier versions will send NA
reports if they occur or a user might have changed the defaults so
as to send NA reports.

Generally, module authors may simply choose to ignore NA reports.

= SENDING REPORTS

== Why did I get a error sending a test report?

Test reports are sent via ordinary email.  The most common reason for errors
sending a report is that many Internet Service Providers (ISP's) will block
outbound SMTP (email) connections as part of their efforts to fight spam.
Instead, email must be routed to the ISP's outbound mail servers, which will
relay the email to the intended destination.

You can configure CPAN::Reporter to use a specific outbound email server 
with the {smtp_server} configuration option.

 smtp_server = mail.some-isp.com

In at least one case, an ISP has blocked outbound email unless the 
"from" address was the assigned email address from that ISP.

== Why didn't my test report show up on CPAN Testers?

CPAN Testers uses a mailing list to collect test reports.  If the email
address you set in {email_from} is subscribed to the list, your emails
will be automatically processed.  Otherwise, test reports will be held 
until manually reviewed and approved.  

Subscribing an account to the cpan-testers list is as easy as sending a blank
email to cpan-testers-subscribe@perl.org and replying to the confirmation
email.

There is a delay between the time emails appear on the mailing list and the
time they appear on the CPAN Testers website. There is a further delay before
summary statistics appear on search.cpan.org.

If your email address is subscribed to the list but your test reports are still
not showing up, your outbound email may have been silentely blocked by your
ISP.  See the question above about errors sending reports.

= CPAN TESTERS

== Where can I find statistics about reports sent to CPAN Testers?

CPAN Testers statistics are compiled at [http://perl.grango.org/]

== How do I make sure I get credit for my test reports?

To get credit in the statistics, use the same email address wherever 
you run tests.

For example, if you are a CPAN author, use your PAUSEID email address.

 email_from = pauseid@cpan.org

Otherwise, you should use a consistent "Full Name" as part of your 
email address in the {email_from} option.

 email_from = "John Doe" <john.doe@example.com> 

= SEE ALSO

* [CPAN::Reporter]
* [Test::Reporter]

= AUTHOR

David A. Golden (DAGOLDEN)

dagolden@cpan.org

http://dagolden.com/

= COPYRIGHT AND LICENSE

Copyright (c) 2006 by David A. Golden

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with
this module.

= DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=end wikidoc


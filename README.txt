sqltools

A small collection of CGI SQL tools.
You will need to set some variables in the sqllib.pl script,
and make sure that the require statements in each script
point at the correct location for this script.
You will need to have David Roth's ODBC.pm package installed.
That package is available at CPAN.  You will need to have 
DSN's configured on the server machine to point to the ODBC
databases that you are interested in.  If you do not know 
what ODBC and/or DSNs are, get someone else to configure
stuff for you.  I am not an expert in those fields. I know
enough to get by.

Note that this will work only on Windows NT, and only with the
above mentioned components correctly installed.  I am thinking
about writing a similar utility for 

Access the top script by
http://yourserver/cgi-bin/path/sqltools.pl

Note that this script will open up your ODBC databases for everyone
to see, and so it is inadvisable to run it on anything but a secure
network, such as an Intranet.  

This code is provided without warranties of any kind, explicit
or implied.  It is not guaranteed to work.  It is not guaranteed to 
melt in your mouth, but not in your hands.

You may use this code freely - that is, it is placed in the public
domain by the author.

Rich Bowen
rbowen@rcbowen.com
rbowen@databeam.com
http://www.rcbowen.com/
http://www.databeam.com/
Real programmers don't document their code.  If it was hard to write,
it should be hard to understand.  If you don't like my documentation,
remember how much you paid for it.  If you like my work, remember 
that I do contract Perl CGI programming for a small fee.
___________________________________________________
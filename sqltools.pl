#  ODBC - SQL utilities
#	Main index script.  This will ask for the name of the DSN
#   Of course, you must already have the DSN configured
#	correctly, or nothing will work
#	This is also only going to work in the Windows world
#	You must have ODBC.pm (David Roth) installed correctly
#
#	Rich Bowen
#	rbowen@databeam.com
#	12/4/1996
###########

#  Index works in several steps:
#	1. Select the DSN
#	2. Select the function you wish to perform on that DSN
#	
#	I will determine what step we are on by the presence of QUERY_STRING
####
require "c:\\httpd\\cgi-bin\\sqltools\\sqllib.pl";

#  Print the http header
&header;

if ($ENV{QUERY_STRING})	{&functions}
else	{&SelectDSN}

########################


sub SelectDSN	{
#  Determine what DNS we are going to be dealing with, and pass it 
#  in the "command line"

print <<EndHead;
<html>
<head><title>Select a DSN</title>
</head>
<body>
<h2>Select a DSN</h2>
If there are no DNSs listed below, or you do not know
what a DSN is, read the FAQ (useful link here later)
<ul>
EndHead

%DSNs = Win32::ODBC::DataSources();

if (%DSNs)	{
	for (keys %DSNs)	{
		print "<li><a href=\"sqltools.$ext?dsn=$_\">$_<br></a>\n"
		}
	}
else { print "No DSNs were found.\n"	}

print <<endFoot;
</ul>
Or, <a href="sqlqry.pl">preform an arbitrary SQL query</a>.
<hr>
</body></html>
endFoot

}  # End sub SelectDSN

sub functions	{
#  Determine which function is to be performed on that DSN

print <<EndOptions;
<html>
<head>
<title>Select an option</title>
</head>

<body>
<h2>Select an option:</h2>

<ul>
<li><a href="Select.$ext?$ENV{QUERY_STRING}">Select record(s)
<li><a href="insert.$ext?$ENV{QUERY_STRING}">Insert into a table</a>
<li>Update a record
<li>Delete a record
</ul>

EndOptions
}
#  End sub functions
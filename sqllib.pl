#  sqllib.pl
#  Lib of shared functions and variables
#	Should be require'd by each script.

#  Initialize the ODBC stuff
use Win32::ODBC;

# Url of base directory
$base_url = "/sqltools";

#  More stuff to set.
$ext="pl";
$uid="sa";
$pwd="";

sub SelectTable	{
# We'll need to do this in all the routines ...
$calling_routine = $_[0];
@tables=$Data->TableList();

print "<h2>Select a table:</h2>";
print "<ul>";

for (@tables)	{
	print "<a href=\"$calling_routine.$ext?dsn=$dsn&table=$_\"><li>$_</a>\n";	}
print "</ul>";

}	 #  End SelectTable

sub commandline	{
#  Get the "command line"
($dsn,$table) = split (/&/,$ENV{QUERY_STRING});  #  Just in case ...
$dsn =~ s/^dsn=//;
$table =~ s/^table=//;
}  #  End sub commandline

sub colnames	{
# Get the col names
$Data->Sql("SELECT * FROM $table");
$Data->FetchRow();
%fields=$Data->DataHash;
}

sub header	{
	print "content-type: text/html \n\n";
	}

sub footer	{
# Print the HTML footer	with context-relevant links
# Usage: &footer(calling_routine,dsn,table)

print <<EndFoot1;
<p>
<hr>
<center>
[
<a href="$base_url/sqltools.$ext">SQL Tools</a>
EndFoot1

if ($_[0] ne "tools" && $table ne "")
	{print " | <a href=\"$base_url/$_[0].$ext?dsn=$dsn&table=$table\">$_[0] another record</a>"}
print <<EndFoot2
]
</center>
EndFoot2

#  Stuff like $routine another record, where $routine is delete, insert, etc

}	#  End sub footer

#  form_parse:  Reads in the form information from a post and
#  parses it out into $FORM{'variable_name'}
sub form_parse  {
        # Get the input 
        read (STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

        # Split the name-value pairs
        @pairs = split(/&/, $buffer);

        foreach $pair (@pairs)
        {
        ($name, $value) = split(/=/, $pair);

        # Un-Webify plus signs and %-encoding
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

        # Stop people from using subshells to execute commands
        # Not a big deal when using sendmail, but very important
        # when using UCB mail (aka mailx).
        # $value =~ s/~!/ ~!/g;

        # Uncomment for debugging purposes
        # print "Setting $name to $value<P>";

        $FORM{$name} = $value;
        }     # End of foreach
        }       #  End of sub

#  End on a positive note ...
1;
#  Insert.pl
#  Part of the SQLTools application
#
#	The purpose of this one is to insert a record into a table
#	The DSN is passed in via QUERY_STRING
#
#	So, three steps - (1) select a table,
#		 (2) display a form with all the fields,
#	and  (3) insert the data.
require "c:\\httpd\\cgi-bin\\sqltools\\sqllib.pl";

#  Print the http header
&header;

#  Get the "command line"
&commandline;

#  And open the data connection
$Data = new Win32::ODBC("dsn=$dsn;uid=$uid;pwd=$pwd;");

# First, determine what step we are on
if ($ENV{QUERY_STRING} =~ /&/)	{  # step 2 or 3
	&form_parse;
	if ($FORM{routine} eq "insert")	{ # step 3
		&insert	}
	else	{	# Step 2
		&form	}
	}  #  Endif
else {&SelectTable(insert);} # This is in sqllib.pl

$Data -> Close();

###########

sub form	{
#  Print the HTML form with all the fields
#  The connection should already be open

# Get the col names
$Data->Sql("SELECT * FROM $table");
$Data->FetchRow();
%fields=$Data->DataHash;

print <<EndFormHead;
<html>
<head><title>Insert a record</title></head>
<body>
<h2>INSERT INTO $table</h2>
<form action="insert.$ext?dsn=$dsn&table=$table" method=POST>
<input type=hidden name="routine" value="insert">
<table>
EndFormHead

for (keys %fields)	{
	#  print the rows of the form
print <<EndField;
<tr>
<td align=right>$_
<td><input name="$_">
EndField
	}

print <<EndFormFoot;
<td align=center colspan=2>
<input type=submit value="Insert Record">
</table>
</form>

</body></html>
EndFormFoot

}	#  End sub form

sub insert	{
#  Do the actual insertion into the database

#  Already got the form data in %FORM
#  Need to build sql statement
#
#	INSERT INTO table (column,column,...)
#			VALUES (val,val,...)

for (keys %FORM)	{
	unless (($_ eq "routine") || ($FORM{$_} eq ""))	{
		$cols .= ",$_";
		$vals .= ",'$FORM{$_}'";	}
	}
$cols =~ s/^,//;
$vals =~ s/^,//;

$Data->Sql("INSERT INTO $table ($cols) VALUES ($vals)");

print <<EndHTML1;
<html>
<head><title>Item inserted</title></head>
The SQL query executed:<br>
<b>INSERT INTO $table ($cols) VALUES ($vals)</b><br>

The error messages (if any) returned from the ODBC source:<br>
<b>
EndHTML1

@error=$Data->Error();
print "<b>$error[1]</b>";
			   
&footer(insert,$dsn,$table);
			   
print <<EndHTML2;
</body></html>
EndHTML2
}  # End sub insert


#  Select.pl
#  Select record(s) from a table
#
#	Should list all the fields, and have a WHERE option also

require "c:\\httpd\\cgi-bin\\sqltools\\sqllib.pl";

#  Again, three steps:
#	1) Select a table
#	2) display form with fields
#	3) Perform the query

#  Print the http header
&header;

#  Get the "command line"
&commandline;

#  And open the data connection
$Data = new Win32::ODBC("dsn=$dsn;uid=$uid;pwd=$pwd;");

#  OK, determine what part we are calling
if ($ENV{QUERY_STRING} =~ /&/)	{  # step 2 or 3
	&form_parse;
	if ($FORM{routine} eq "Select")	{ # step 3
		&Select	}
	else	{	# Step 2
		&form	}
	}  #  Endif
else {&SelectTable(Select);} # This is in sqllib.pl
#  Notice the capital letters on Select.  'select' is a reserved word, 'Select' is not.

###################################

sub form	{
#  Print the HTML form for constructing the query
#  Two parts - the select fields part and the WHERE part

# Get the col names
&colnames;

print <<EndFormHead;
<html>
<head><title>Select record(s)</title></head>
<body>
<h2>SELECT</h2>
<form action="select.$ext?dsn=$dsn&table=$table" method=POST>
<input type=hidden name="routine" value="Select">
<table>
<tr><td><input type=checkbox name="star" checked>
<td>*  (Note: Selecting this overrides all other selections)
EndFormHead

for (keys %fields)	{
print <<EndField;
<tr><td><input type=checkbox name="$_">
<td>$_
EndField
}

print <<EOT;
</table>
<h2> FROM $table WHERE</h2>
<table>
EOT

for (keys %fields)	{
print <<EndField;
<tr>
<td align=right>$_
<td><select name="where$_">
<option>=
<option>like
<option>&lt;
<option>&gt;
<option>&lt;&gt;
</select>
<input name="value$_">
EndField
   }

print <<EndFormFoot;
<td align=center colspan=3>
<input type=submit value="Select Record">
</table>
</form>

</body></html>
EndFormFoot

}	#  End sub form

sub Select	{
#  Create and execute the SQL SELECT statement

#  I think that the easiest way to do this is to get a field list again.
&colnames;

# for(keys %FORM){print "$_ = $FORM{$_}<br>\n";}
for (keys %fields)	{
	if ($FORM{$_}) 
		{$selected .= ",$_"};
	if ($FORM{"value$_"})
		{
		if ($FORM{"where$_"} eq "like") {$FORM{"value$_"} = "%" . $FORM{"value$_"} . "%"};
		$where .= "AND $_ " . $FORM{"where$_"} . " '" . $FORM{"value$_"} . "' ";
			}
		}
$selected =~ s/^,//;
$where =~ s/^AND//;

if ($FORM{star}) {$selected = "*"};

$Data->Sql("SELECT $selected FROM $table WHERE $where");

print <<EndHTML1;
<html>
<head><title>SELECT results</title></head>
The SQL query executed:<br>
<b>SELECT $selected FROM $table WHERE $wher</b><br>

The error messages (if any) returned from the ODBC source:<br>
<b>
EndHTML1

@error=$Data->Error();
print "<b>$error[1]</b>";

#  Now to print the query results, if any
print "<table>\n";

while ($Data->FetchRow())	{
	%record=$Data->DataHash;
	print "<tr>";
	for (keys %record)	{
		print "<td>$record{$_}";	}
		}

print "</table>";
			   
&footer(Select,$dsn,$table);

		   
print <<EndHTML2;
</body></html>
EndHTML2
}  #  End sub select

use Win32::ODBC;

#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
print <<EOT;
content-type: text/html

<html>
<body>
<form method=POST action="/sqltools/sqlexe.pl">

<table>
  <tr>
    <td>Data Source
    <td><select name="dsn">
EOT

#-----------------------------------------------------------------------
%DSNs = Win32::ODBC::DataSources();

if (%DSNs) {
  foreach (keys %DSNs){
    print "<option>$_\n";
  }
}

#-----------------------------------------------------------------------
print <<EOT2;
  </select>

  <tr>
    <td>User
    <td><input type=TEXT name="usr">

  <tr>
    <td>Password
    <td><input type=PASSWORD name="pwd">
</table>

<p>
<textarea name="qry" wrap=virtual cols=70 rows=10>
</textarea>

<p>
<input type=SUBMIT value="Execute">

</form>
</body>
</html>
EOT2

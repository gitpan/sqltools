require "c:\\httpd\\cgi-bin\\sqltools\\sqllib.pl";

#-----------------------------------------------------------------------
&form_parse();

#-----------------------------------------------------------------------
print <<EOT;
Content-type: text/html

<html>
<body>
EOT

#-----------------------------------------------------------------------
$dsn = $FORM{'dsn'};
$usr = $FORM{'usr'};
$pwd = $FORM{'pwd'};
$qry = $FORM{'qry'};

$db = new Win32::ODBC("dsn=$dsn;uid=$usr;pwd=$pwd;");

if ($db) {
  $db->Sql($qry);

  @flds = $db->FieldNames();
  $cols = $#flds + 1;
  $cnt  = 0;

  print "<p><table width=100%><tr>\n";

  for ($i = 0; $i < $cols; $i++) {
    print "<td bgcolor=MAROON><font size=+1 color=WHITE>$flds[$i]</font>\n";
  }

  while ($db->FetchRow()) {
    undef %Data;

    @Data = $db->Data();

    print "<tr>\n";

    for ($i = 0; $i < $cols; $i++) {
      print "<td bgcolor=WHITE>$Data[$i]\n";
    }

    $cnt++;
  }

  print "</table>\n";
  print "<p><b>$cnt Matching Records</b>\n";

  $db->Close();
}

#-----------------------------------------------------------------------
print <<EOT;
</body>
</html>
EOT

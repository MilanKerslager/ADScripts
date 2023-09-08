# | Select-object Name, LastLogonDate
Get-ADUser -Filter * -Properties * | export-csv -Encoding UTF8 -path allusers.csv
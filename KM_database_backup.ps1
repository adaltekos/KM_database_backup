$backupDirectory = "" #complete with local backup directory (ex. C:\backup\postgresql_backup)
$onlineDirectory = "" #complete with online backup directory (ex. \\192.168.0.0\backup_servers\postgresql_backup)

$sqdb6 = "$backupDirectory\SQDB6_" + (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss') + ".backup" 
$sqdb6ims = "$backupDirectory\SQDB6_IMS_" + (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss') + ".backup"

&$env:SAFEQ_HOME\PGSQL\bin\pg_dump.exe --host localhost --port 5433 --username "postgres" --role "postgres" --format custom --blobs --verbose --file $sqdb6 "SQDB6"
&$env:SAFEQ_HOME\PGSQL\bin\pg_dump.exe --host localhost --port 5433 --username "postgres" --role "postgres" --format custom --blobs --verbose --file $sqdb6ims "SQDB6_IMS"

#Delete items in local directory that are older than 7 days
Get-ChildItem "$backupDirectory\*.backup" |? { $_.lastwritetime -le (Get-Date).AddDays(-7)} |% {Remove-Item $_ -force }
#Copy all items that were create today and copy them to $onlineDirectory
Get-ChildItem "$backupDirectory\*.backup" |? { $_.lastwritetime -ge (Get-Date).AddDays(-1)} |% {Copy-Item $_ -Destination $onlineDirectory }
#Delete all items that are older than 7 days and were not created on Sundays, or delete them always if they are older than 90 days
Get-ChildItem "$onlineDirectory\*.backup" |? {((($_.lastwritetime -lt (Get-Date).AddDays(-7)) -and ($_.lastwritetime.Dayofweek -ne 'Sunday')) -or ($_.lastwritetime -lt (Get-Date).AddDays(-90)))} |% {Remove-Item $_ -force }
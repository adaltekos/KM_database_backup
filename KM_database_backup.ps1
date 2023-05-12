# Set local and online backup directories
$backupDirectory = "" # Complete with local backup directory (ex. C:\backup\postgresql_backup)
$onlineDirectory = "" # Complete with online backup directory (ex. \\192.168.0.0\backup_servers\postgresql_backup)

# Set backup file names with current date and time stamp
$sqdb6 = "$backupDirectory\SQDB6_" + (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss') + ".backup" 
$sqdb6ims = "$backupDirectory\SQDB6_IMS_" + (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss') + ".backup"

# Backup databases using pg_dump.exe
& $env:SAFEQ_HOME\PGSQL\bin\pg_dump.exe --host localhost --port 5433 --username "postgres" --role "postgres" --format custom --blobs --verbose --file $sqdb6 "SQDB6"
& $env:SAFEQ_HOME\PGSQL\bin\pg_dump.exe --host localhost --port 5433 --username "postgres" --role "postgres" --format custom --blobs --verbose --file $sqdb6ims "SQDB6_IMS"

# Delete items in local directory that are older than 7 days
Get-ChildItem "$backupDirectory\*.backup" |
Where-Object { $_.lastwritetime -le (Get-Date).AddDays(-7)} |
ForEach-Object { Remove-Item $_ -Force }

# Copy all items that were created today and copy them to $onlineDirectory
Get-ChildItem "$backupDirectory\*.backup" |
Where-Object { $_.lastwritetime -ge (Get-Date).AddDays(-1)} |
ForEach-Object { Copy-Item $_ -Destination $onlineDirectory }

# Delete all items that are older than 7 days and were not created on Sundays, or delete them always if they are older than 90 days
Get-ChildItem "$onlineDirectory\*.backup" |
Where-Object { ((($_.lastwritetime -lt (Get-Date).AddDays(-7)) -and ($_.lastwritetime.DayOfWeek -ne 'Sunday')) -or ($_.lastwritetime -lt (Get-Date).AddDays(-90))) } |
ForEach-Object { Remove-Item $_ -Force }

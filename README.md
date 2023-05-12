# Script for Konica Minolta Dispatcher Paragon PostgreSQL Databases Backup

## Description
This script is used to backup two PostgreSQL databases, `SQDB6` and `SQDB6_IMS`, and copy the backup files to a local and online backup directory. It also deletes backup files that are older than 7 days in the local directory and older than 7 days and were not created on Sundays or older than 90 days in the online directory.

## Prerequisites
- PowerShell version 3.0 or later.
- Microsoft.SqlServer.SmoExtended library.

## Configuration
1. Set the local backup directory by providing the path to the `$backupDirectory` variable. For example, `$backupDirectory = "C:\backup\postgresql_backup"`.
2. Set the online backup directory by providing the path to the `$onlineDirectory` variable. For example, `$onlineDirectory = "\\192.168.0.0\backup_servers\postgresql_backup"`.
3. Check if the `$env:SAFEQ_HOME` is set to the PostgreSQL installation directory.
4. Provide the password to the `$mySrvConn.Login` and `$mySrvConn.Password` variables, respectively.

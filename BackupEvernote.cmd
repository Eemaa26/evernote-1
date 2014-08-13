REM Script to backup all Evernote Notes to a predefined path.
REM Inspired by Jamie Todd Rubin - http://www.jamierubin.net/2014/08/12/going-paperless-how-and-why-ive-automated-backups-of-my-evernote-data/

REM Set your backup path for Evernote below.
SET BackupPath=C:\Users\username\Documents\Evernote Backup
REM Set the name of your notebook you want to write your backup log to.
SET notebook=Timeline

REM Get the current date for naming the backup file.  Date will be in the order from your regional settings.
REM For example MM/DD/YYYY will become MMDDYYYY, and DD-MM-YYYY will become DDMMYYYY
REM Thanks to Rob van der Woude - http://www.robvanderwoude.com/datetimentbasics.php
FOR %%A IN (%Date%) DO SET Today=%%A
FOR /F "tokens=1-3 delims=/-" %%A IN ("%Today%") DO SET BackupDate=%%A%%B%%C

REM Get path for ENScript.exe
REM Thanks to fzzylogic - http://community.spiceworks.com/scripts/show/1360-grab-registry-key-value-with-spaces-to-variable
for /f "tokens=3-7" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ENScript.exe" ^| find /i "default"') do set EnScriptPath=%%a %%b %%c %%d %%e

REM Run a Sync first
"%EnScriptPath%" syncDatabase

REM Run the Backup
"%EnScriptPath%" exportNotes /q any: /f "%BackupPath%\%BackupDate%.enex"

REM Write a note stating the backup completed successfully.
IF %errorlevel% == 0 (
echo Run @ %time% | "%EnScriptPath%" createNote /n %notebook% /i "Full Backup taken on %date%"
)

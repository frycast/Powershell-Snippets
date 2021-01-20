### Get-Command, Get-Help and Get-Member are the most important
### for learning
### video links: 
### - https://www.youtube.com/watch?v=FiTZgpRpWv0
### - https://www.youtube.com/watch?v=QKmyf6c83Rs&list=PL2j0_s2VJe2hzQuQyn6yfMS2olhhs4UnQ&index=3

# commands are called commandlets (cmdlet)
# follows verb-noun structure
# Get indicates a read-only action
# also indicates there may be actionable 
# version like Set-Timezone
Get-Timezone

# Get every cmdlet
Get-Command 

# Get commands with process in them using wildcard
Get-Command *process*

# Update help must be run in administrator
Update-Help

# Get help on the process called Stop-Process
Get-Help Stop-Process
Get-Help Stop-Process -examples
Get-Help Stop-Process -online

# Piping to Get-Member to determine object type
# and the methods and properties that can be used
Get-Date | Get-Member

# Formatting the System.DateTime object to see the 
# values of all the properties 
Get-Date | Format-List

# Return a random number and pipe object to Get-Member
Get-Random | Get-Member

# Find a module from the powershell community that 
# has the tag "Telegram"
Find-Module -Tag Telegram

# List all processes
Get-Process

# Sort the processes by Id
Get-Process | Sort-Object Id

# Get all running processes with firefox in ProcessName 
Get-Process *firefox*

# Stop the notepad process
Get-Process notepad | Stop-Process

# Note all cmdlets accept pipeline input
# but Get-Help can show you which parameters
# accept pipeline input
Get-Help Stop-Process -online

# $psitem contains the current object in the pipeline
# ForEach-Object is a for loop and $psitem is the object
Get-Process | ForEach-Object {$psitem}
1,2,3 | ForEach-Object {$psitem}

# We can also just write $_ instead of $psitem
1,2,3 | ForEach-Object {$_}

# Tables are a good way to display information
Get-Date | Format-Table

# Lists are a good way to display all the data in an object
# but the astrix is needed to print all the information
Get-Process firefox | Format-List *

# we can also select only the properties of interest
Get-Process firefox | Select-Object Name,Id,CPU,Responding

# We can also sort by a property of interest
Get-Process | Sort-Object CPU 
Get-Process | Select-Object Name,Id,CPU,Responding | Sort-Object CPU

# Get Processes with CPU usage greater than 50
Get-Process | Where-Object {$_.CPU -gt 50}

# Get all child items of home path recursively, then select
# only the objects greater than 20MB in length
# then count the number of files with Measure-Object
Get-ChildItem -Path $HOME -Recurse | Where-Object {$_.Length -gt 20MB} | Measure-Object

# Parameters are the things that look like flags
# You can type - and then tab through all parameters
# and shift-tab goes backwards
Get-Timezone -ListAvailable

# Whatif flag checks what would happen 
Get-Process | Stop-Process -whatif

# Change all txt files in all subfolders to sql files. Path is a class from the System.IO namespace, with method ChangeExtension,
# that takes two strings as input. Notice there is no need to use ForEach-Object here.
Get-ChildItem X:\mypath\ -Filter *.txt -Recurse | Rename-Item -NewName {[System.IO.Path]::ChangeExtension($_.Name, ".sql")}

# Check powershell version and other info
$PSVersionTable

# Count the number of commands
Get-Command | Measure-Object

# The command below should trigger warnings 
# in the PCAScriptAnalyser in vscode. Query-Demo
# is an unapproved verb and gci is an alias for get-ChildItem
function Query-Demo {
    gci c:\dsc
}

# Piping a variable to use filter and sort.
$process = Get-Process
$process | Where-Object {$_.CPU -gt 5000}
$process | Sort-Object WorkingSet64 -Descending

# Note that powershell is not statically typed.
$total = 2+2
$total | Get-Member
# --------------------
$total = '2+2'
$total | Get-Member
# --------------------
$num1 = '2'
$num2 = '2'
$total = $num1 + $num2
$total
# --------------------
[int]$num1 = '2'
[int]$num2 = '2'
$total = $num1 + $num2
$total

# Even basic data types have methods
$total = '4'
$stringReturn = $total.ToString()
$stringReturn

# Single quotes doesn't allow $ escape but double quotes does
$literal = 'Three equals $(1+2)'
$literal
$escaped = "Three equals $(1+2)"
$escaped
# --------------------
Write-Host '$escaped'
Write-Host "$escaped"

# List all variables in the current session
Get-Variable

# Also some env variables, specific to the env (this session)
Get-ChildItem env:

# To access environment variables we need to type env
$env:COMPUTERNAME
$env:USERNAME

# Putting it all together so far (with variables)
$path = Read-Host -Prompt 'Please enter the file path you wish to scan for large files...'
$rawFileData = Get-ChildItem -Path $path -Recurse
$largeFiles = $rawFileData | Where-Object {$_.Length -gt 100MB}
$largeFilesCount = $largeFiles | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "You have $largeFilesCount large file(s) in $path"

# Tab completion and conditional if statement example
$path = 'C:\Test'
$evalPath = Test-Path $path
if ($evalPath -eq $true) {
  Write-Host "$path VERIFIED"  
}
elseif ($evalPath -eq $false) {
    Write-Host "$path NOT VERIFIED"
}

# Switch with strictly typed variable
[int]$aValue = Read-Host 'Enter a number'
switch ($aValue) {
    1 { 
        Write-Host 'You entered the number ONE'
    }   
    2 { 
        Write-Host 'You entered the number TWO'
    }   
    Default { "Sorry, I don't know what to do with $aValue" }
}

# Rainbow for loop example
for ($i = 0; $i -lt 15; $i++) {
    Write-Host $i -ForegroundColor $i
}

# Reverse string for loop
$aString = 'Jean-Luc Picard'
$reverseString = ''
for ($i = $aString.Length; $i -ge 0; $i--) {
    $reverseString += $aString[$i]
}
$reverseString

# Foreach loop example
$testPath = 'C:\Test'
[int]$totalSize = 0
$fileInfo = Get-ChildItem $testPath -Recurse
foreach ($file in $fileInfo) {
    $totalSize += $file.Length
}
Write-Host "The total size of file in $path is $($totalSize / 1MB) MB."

# do-while loop with the -eq left out in the if condition
$pathVerified = $false
do {
    $path = Read-Host 'Please enter a file path to evaluate'
    if (Test-Path $path) { # -eq is left out 
        $pathVerified = $true
    }
} while ($pathVerified -eq $false)

# while loop
$pathVerified = $false
while ($pathVerified -eq $false) {
    $path = Read-Host 'Please enter a file path to evaluate'
    if (Test-Path $path) { # -eq is left out 
        $pathVerified = $true
    }    
}

# Native cmdlets that perform conditional logic
$largeProcesses = Get-Process | Where-Object { $_.WorkingSet64 -gt 50MB }
# -- the above is the same as:
$largeProcesses = @()
$processes = Get-Process
foreach ($process in $processes) {
    if ($process.WorkingSet64 -gt 50MB) {
        $largeProcesses += $process
    }
}

# The ForEach-Object cmdlet performs conditional logic
$folderCount = 0
Get-ChildItem 'C:\Test' | ForEach-Object -Process { 
    if ($_.PSIsContainer) { 
        $folderCount++ 
    } 
}

# Get JSON input from webpage 
$webResults = Invoke-WebRequest -Uri 'https://reddit.com/r/powershell.json'
$rawJSON = $webResults.Content
$objData = $rawJSON | ConvertFrom-Json
$posts = $objData.data.children.data
$posts | Select-Object Title,Score | Sort-Object Score -Descending

# Get fist few posts based on user input number
[int]$numPosts = Read-Host -Prompt "Enter the number of posts to read"
$posts | Select-Object Title,url | Select-Object -First $numPosts

# Extracting error from a log and finding the errors with an IP address
$logContent = Get-Content C:\Test\SampleLog.log
$logContent | Select-String -Pattern "error"
$regex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
$logContent | Select-String -Pattern $regex -AllMatches
$logContent | Where-Object {$_ -like "*.*.*.*"}

# Raw data behaves differently because it's individual character information
# so it can't be parsed the same way
$raw = Get-Content C:\Test\SampleLog.log -Raw
$raw | Get-Member
$raw | Select-String -Pattern "error"
$raw[0]

# Import a csv and convert it to powershell object
$rawCSV = Get-Content C:\Test\testCSV.csv
$objData = $rawCSV | ConvertFrom-Csv

# Note that Write-Host is considered harmful. (Use Write-Verbose instead?) use Write-Output instead.
Write-Host "Hello"
$hostInfo = Get-Host
Write-Host $hostInfo.Version

# Changing background and foreground
Write-Host "CRITICAL ERROR" -BackgroundColor Red -ForegroundColor White

# Write-Output is just like typing the name into the console and hitting enter
$processes = Get-Process
Write-Output $processes
Write-Host $processes
$processes | Out-File -Path C:\Test\processInfo.txt
$processes | ConvertTo-Csv -NoTypeInformation | Out-File C:\Test\processInfo.csv

# Read student names from a csv file and create empty docx file for each of them
$path = "D:\path\to\folder\"
$studentList = Get-Content $path\student-list.csv | ConvertFrom-Csv
$studentList.Student | ForEach-Object {
  New-Item -Path ($path+($_+".docx").Replace(" ","-")) -ItemType File
}

# Read student names from a csv file and copy template docx file for each of them
$path = "D:\path\to\folder\"
$studentList = Get-Content $path\student-list.csv | ConvertFrom-Csv
$studentList.Student | ForEach-Object {
    Copy-Item -Path $path\Feedback-template.docx -Destination ($path+($_+".docx").Replace(" ","-"))
}

# Define an array and loop over it
$a = @("a","b","c")
$a | ForEach-Object {Write-Output $_}


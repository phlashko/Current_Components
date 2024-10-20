# Run as Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs }

# Color Functions
cls ; function Green { param ($Text) ; Write-Host $Text -ForegroundColor Green -NoNewline } ; function Yellow { param ($Text) ; Write-Host $Text -ForegroundColor Yellow } ; function Cyan { param ($Text) ; Write-Host $Text -ForegroundColor Cyan }

# Get Motherboard Model
$motherboard = $motherboardInfo = Get-CimInstance Win32_BaseBoard ; $manufacturer = $motherboardInfo.Manufacturer ; $model = $motherboardInfo.Product

# Get CPU Information
$cpus = Get-WmiObject -Class "Win32_Processor" -Namespace "root\CIMV2" | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

# Get Memory Information
$sticks = Get-WmiObject -Class "Win32_PhysicalMemory" -Namespace "root\CIMV2" | Select-Object Capacity,PartNumber

# Get Hard Drive Information
$disks = Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size

# Display Motherboard Results
cls ;  Yellow "`n ~~~~ Motherboard ~~~~`n" ; Green "  - Manufacturer: " ; Write-Host -NoNewline "$manufacturer`- $model`n`n"

# Display CPU Results
Yellow " ~~~~~~~~ CPU ~~~~~~~~`n" ; $cpuCounter = 1 ; foreach ($cpu in $cpus) { Cyan "  - CPU ${cpuCounter}:" ; Green "    - Name: " ; Write-Host -NoNewline " $($cpu.Name)`n" ; Green "    - Number of Cores: " ; Write-Host -NoNewline " $($cpu.NumberOfCores)`n" ; Green "    - Number of Logical Processors: " ; Write-Host -NoNewline " $($cpu.NumberOfLogicalProcessors)`n`n" ; $cpuCounter++ }

# Display Memory Results
Yellow " ~~~~~~~ Memory ~~~~~~`n" ; $memcounter = 1 ; foreach ($stick in $sticks) { $sizeGB = [math]::round($stick.Capacity / 1GB, 2) ; Cyan "  - Memory Stick ${memcounter}:" ; Green "    - Size: " ; Write-Host -NoNewline "$sizeGB GB`n" ; Green "    - Part Number: " ; Write-Host -NoNewline " $($stick.PartNumber)`n`n" ; $memcounter++ }

# Display HD Results
Yellow " ~~~~ Hard Drives ~~~~`n" ; $HDcounter = 1 ; foreach ($disk in $disks) { $sizeGB = [math]::round($disk.Size / 1GB, 2) ; Cyan "  - Drive ${HDcounter}:" ; Green "    - Media Type:" ; Write-Host -NoNewline " $($disk.MediaType)`n" ; Green "    - HD Type: " ; Write-Host -NoNewline " $($disk.FriendlyName)`n" ;  Green "    - Size: " ; Write-Host -NoNewline " $sizeGB GB`n`n" ; $HDcounter++ }
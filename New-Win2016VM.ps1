Clear-Host

$BootFile = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\efisys_noprompt.bin"
$StagingDir = "D:\Windows 2016\Win2016_Staging"
$IsoPath = "D:\WIN2016Auto.iso"
$Title = "Win2016Auto"
$Media = ""
$VM = "Win2016Auto"
$Unattend = 'D:\Windows 2016\WindowsServer2016TP5_AutoUnattend.xml'

# Set VM to boot from DVD
$dvd = Get-VMDvdDrive -VMName $VM
Set-VMFirmware -VMName $VM -BootOrder $dvd,$network
#Get-VMFirmware -VMName $VM
#break

$VM0bj = get-vm $VM
if($VMObj.state -match "Off"){$VMObj | Start-VM}

#Eject ISO
Set-VMDvdDrive Win2016Auto -Path $Null

if(test-path $IsoPath){remove-item $IsoPath}

Copy-Item $Unattend "$StagingDir\autounattend.xml" -Force

dir $StagingDir | New-IsoFile -Path $IsoPath -BootFile $BootFile -Media DVDPLUSR -Title $Title


Set-VMDvdDrive $VM -Path $IsoPath
Get-VM $VM | Restart-VM -Force


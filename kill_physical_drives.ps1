# Get the disk where the OS is installed
$osDisk = Get-WmiObject -Query "SELECT * FROM Win32_DiskDrive WHERE MediaType='Fixed' AND InterfaceType!='USB'"

# Get all physical disks except the OS disk
$physicalDisks = Get-PhysicalDisk | Where-Object { $_.DeviceId -ne $osDisk.Index }

# Clear the partitions and format each physical disk
foreach ($disk in $physicalDisks) {
    Write-Host "Cleaning Disk $($disk.DeviceId)..."
    
    # Clear all partitions on the disk
    Get-Disk -Number $disk.DeviceId | Clear-Disk -RemoveData -Confirm:$false
    
    # Initialize the disk
    Get-Disk -Number $disk.DeviceId | Initialize-Disk -PartitionStyle GPT
    
    # Create a new partition and format it
    New-Partition -DiskNumber $disk.DeviceId -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false
}

Write-Host "Disk cleaning completed."

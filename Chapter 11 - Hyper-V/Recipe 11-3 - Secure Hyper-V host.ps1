﻿# recipe 13-3 - Secure Hyper-V host
# Run on HV1

# 1. Setup Hyper-V VM groups
$VMGroup = New-VMGroup -Name HVServers `
                       -GroupType VMCollectionType

# 2. Assign group members to VM collection group
$HVServers        = 'Book - HV1',
                    'Book - HV2'

# 3. Add members to the VM group Storage, HVServers
Foreach ($HVS in $HVServers) {
    $VM = Get-VM -Name $HVS 
    Add-VMGroupMember -Name HVServers -VM $VM
}

# 4. Get and display VM group details
Get-VMGroup |
    Format-Table -Property Name, GroupType, VMMembers 

# 5. Get VMs in the groups
$Members = (Get-vmgroup -name HVServers).VMMembers
$Members

# 6. Setup and View MAC Addresses
Set-VMhost -ComputerName HV1 -MacAddressMinimum 00155D017000 `
                             -MacAddressMaximum 00155D017099       -Credential $Credrk
Set-VMhost -ComputerName HV2 -MacAddressMinimum 00155D017100 `
                             -MacAddressMaximum 00155D017199       -Credential $Credrk
Get-VMhost -computer HV1, HV2   -credential $credRK |
    Format-Table -Property Name, MacAddressMinimum, MacAddressMaximum

# 7. Stop HV machines
Stop-VM -VM (Get-VMGroup HvServers).VMMembers

# 8. Set Hyper-V Resource Protection
Set-VMProcessor -VM (Get-VMGroup HvServers).VMMembers -EnableHostResourceProtection:$true

# 9. Start HV machines
Start-VM -VM (Get-VMGroup HvServers).VMMembers

# 10. Observe results
Get-VMProcessor -VM (Get-VMGroup HvServers).VMMembers | 
    Format-Table -property VMName, OperationalStatus




<#  clean up
Remove-VMGroupMember -Name VMs -VMGroupMember (Get-Vmgroup HVservers)

Foreach ($SM in $hvservers) {
    $Vm = Get-VM -Name $SM 
    Remove-VMGroupMember -Name HVServers -VM $Vm
}


Get-VMGroup | remove-vmgroup -force

Get-VMgroup|FT
#>




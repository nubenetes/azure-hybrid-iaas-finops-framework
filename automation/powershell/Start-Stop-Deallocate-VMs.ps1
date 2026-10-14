<#
.SYNOPSIS
    FinOps Automation Runbook: Scheduled Deallocation & Start of Non-Production VMs.
.DESCRIPTION
    Scans for VMs tagged with 'AutoShutdown' or 'Environment' matching Dev/Test/QA.
    Transitions VMs to 'Stopped (deallocated)' state to release hypervisor silicon,
    achieving 100% compute charge elimination ($0.00/hr) during off-hours.
.PARAMETER Action
    The operation to execute: 'Stop' (Deallocate) or 'Start'.
.PARAMETER ResourceGroupName
    Optional filter for a specific resource group.
.EXAMPLE
    .\Start-Stop-Deallocate-VMs.ps1 -Action Stop
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Stop', 'Start')]
    [string]$Action,

    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName
)

$ErrorActionPreference = 'Stop'

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " FinOps Compute Lifecycle: VM $Action Orchestration" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Fetch targeted virtual machines
$query = "Resources | where type =~ 'microsoft.compute/virtualmachines'"
if ($ResourceGroupName) {
    $query += " | where resourceGroup =~ '$ResourceGroupName'"
}
$query += " | extend env = tostring(tags['Environment']), autoShutdown = tostring(tags['AutoShutdown']) " +
          " | where env in~ ('Dev', 'Development', 'Test', 'QA', 'Staging') or autoShutdown =~ 'true'" +
          " | project id, name, resourceGroup, env, autoShutdown"

Write-Host "Executing Azure Resource Graph query to identify eligible non-prod VMs..." -ForegroundColor Yellow
$vms = Search-AzGraph -Query $query

if (-not $vms -or $vms.Count -eq 0) {
    Write-Host "No non-production or AutoShutdown tagged VMs found." -ForegroundColor Green
    exit 0
}

Write-Host "Found $($vms.Count) VMs targeted for $Action." -ForegroundColor Green

foreach ($vm in $vms) {
    $vmName = $vm.name
    $rg = $vm.resourceGroup
    
    if ($Action -eq 'Stop') {
        Write-Host "Deallocating VM: $vmName in Resource Group: $rg..." -ForegroundColor Yellow
        # Stop-AzVM with -Force transitions the VM to 'Deallocated', NOT just OS stopped!
        Stop-AzVM -ResourceGroupName $rg -Name $vmName -Force -NoWait
        Write-Host " -> Deallocation initiated. Compute billing paused." -ForegroundColor Green
    }
    elseif ($Action -eq 'Start') {
        Write-Host "Starting VM: $vmName in Resource Group: $rg..." -ForegroundColor Yellow
        Start-AzVM -ResourceGroupName $rg -Name $vmName -NoWait
        Write-Host " -> Startup initiated." -ForegroundColor Green
    }
}

Write-Host "FinOps Lifecycle run completed successfully." -ForegroundColor Cyan

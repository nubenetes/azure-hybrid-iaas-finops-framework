<#
.SYNOPSIS
    FinOps Dynamic Storage Tuning: Online IOPS & Throughput Scaler for Premium SSD v2.
.DESCRIPTION
    Dynamically adjusts provisioned IOPS and Throughput (MB/s) on Premium SSD v2 disks
    with ZERO DOWNTIME. Intended to be triggered by scheduled Azure Automation runbooks
    or cron jobs right before nightly database maintenance/backup windows, and dialed
    down back to standard baseline before business hours.
.PARAMETER ResourceGroupName
    Target Resource Group containing the disk.
.PARAMETER DiskName
    Name of the Premium SSD v2 Managed Disk.
.PARAMETER Mode
    'Boost' (High IOPS for nightly batch) or 'Baseline' (Standard operational IOPS).
.PARAMETER TargetIops
    Explicit IOPS value (optional override).
.PARAMETER TargetThroughputMBps
    Explicit throughput in MB/s (optional override).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$DiskName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Boost', 'Baseline')]
    [string]$Mode,

    [Parameter(Mandatory = $false)]
    [int]$TargetIops,

    [Parameter(Mandatory = $false)]
    [int]$TargetThroughputMBps
)

$ErrorActionPreference = 'Stop'

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " FinOps Premium SSD v2 Dynamic Performance Scaler: $Mode" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$disk = Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName

if ($disk.Sku.Name -ne 'PremiumV2_LRS') {
    Write-Error "Disk $DiskName is SKU '$($disk.Sku.Name)'. Only Premium SSD v2 (PremiumV2_LRS) supports dynamic decoupled performance tuning!"
}

# Determine values based on Mode
if ($Mode -eq 'Boost') {
    $iops = if ($TargetIops) { $TargetIops } else { 20000 }
    $mbps = if ($TargetThroughputMBps) { $TargetThroughputMBps } else { 400 }
}
else {
    # Baseline: 3,000 IOPS and 125 MB/s are included free of charge!
    $iops = if ($TargetIops) { $TargetIops } else { 3000 }
    $mbps = if ($TargetThroughputMBps) { $TargetThroughputMBps } else { 125 }
}

Write-Host "Current configuration for $DiskName: IOPS=$($disk.DiskIOPSReadWrite), MB/s=$($disk.DiskMBpsReadWrite)" -ForegroundColor Yellow
Write-Host "Applying new performance parameters: IOPS=$iops, MB/s=$mbps (Zero Downtime)..." -ForegroundColor Yellow

$diskUpdate = New-AzDiskUpdateConfig -DiskIOPSReadWrite $iops -DiskMBpsReadWrite $mbps
Update-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName -DiskUpdate $diskUpdate

Write-Host "Successfully updated $DiskName to $iops IOPS and $mbps MB/s. Optimization complete!" -ForegroundColor Green

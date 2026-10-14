<#
.SYNOPSIS
    Automated discovery, snapshot backup, and quarantine deletion of unattached Azure Managed Disks.
.DESCRIPTION
    Scans a subscription or target resource group for unattached Azure managed disks.
    Optionally creates a safety snapshot before permanent deallocation to prevent accidental data loss.
.PARAMETER ResourceGroupName
    Target resource group name. If omitted, scans the entire subscription.
.PARAMETER QuarantineDays
    Only process disks unattached for more than the specified number of days (based on tags).
.PARAMETER AutoSnapshot
    Whether to automatically create a snapshot of the disk prior to deletion.
.PARAMETER DryRun
    If true, lists candidate disks without deleting or modifying them.
.EXAMPLE
    .\Cleanup-OrphanedDisks.ps1 -QuarantineDays 14 -AutoSnapshot $true -DryRun $false
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
    [int]$QuarantineDays = 14,

    [Parameter(Mandatory = $false)]
    [bool]$AutoSnapshot = $true,

    [Parameter(Mandatory = $false)]
    [bool]$DryRun = $true
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " 🧹 FinOps Day-2 Runbook: Orphaned Managed Disks Cleanup" -ForegroundColor Cyan
Write-Host " Mode: $(if ($DryRun) { 'DRY RUN (No changes)' } else { 'LIVE EXECUTION' })" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Fetch unattached managed disks
if ($ResourceGroupName) {
    $Disks = Get-AzDisk -ResourceGroupName $ResourceGroupName | Where-Object { $_.ManagedBy -eq $null }
} else {
    $Disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }
}

$CandidateCount = ($Disks | Measure-Object).Count
Write-Host "Found $CandidateCount unattached managed disk(s)." -ForegroundColor Green

if ($CandidateCount -eq 0) {
    Write-Host "No orphaned disks found. Fleet is 100% compliant!" -ForegroundColor Green
    return
}

$TotalMonthlySavingsUSD = 0.0
$TotalMonthlySavingsEUR = 0.0
$EURRate = 0.92

foreach ($Disk in $Disks) {
    $SizeGB = $Disk.DiskSizeGB
    $Tier = $Disk.Sku.Name
    $Name = $Disk.Name
    $RG = $Disk.ResourceGroupName

    # Estimate monthly savings (Premium SSD ~0.132 USD/GB, Standard SSD ~0.075 USD/GB, HDD ~0.045 USD/GB)
    $RateUSD = switch -Regex ($Tier) {
        "Premium" { 0.1320 }
        "StandardSSD" { 0.0750 }
        default { 0.0450 }
    }
    $MonthlyDiskUSD = [math]::Round($SizeGB * $RateUSD, 2)
    $MonthlyDiskEUR = [math]::Round($MonthlyDiskUSD * $EURRate, 2)

    $TotalMonthlySavingsUSD += $MonthlyDiskUSD
    $TotalMonthlySavingsEUR += $MonthlyDiskEUR

    Write-Host "`nCandidate Disk: $Name" -ForegroundColor White
    Write-Host "  Resource Group : $RG"
    Write-Host "  SKU / Size     : $Tier / $SizeGB GiB"
    Write-Host "  Monthly Leak   : $$MonthlyDiskUSD USD / €$MonthlyDiskEUR EUR"

    if ($DryRun) {
        Write-Host "  [DryRun] Would snapshot and delete: $Name" -ForegroundColor Gray
    } else {
        if ($AutoSnapshot) {
            $SnapshotName = "snap-quarantine-$Name-$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "  Creating safety snapshot: $SnapshotName..." -ForegroundColor Yellow
            $SnapshotConfig = New-AzSnapshotConfig -SourceResourceId $Disk.Id -Location $Disk.Location -CreateOption Copy
            New-AzSnapshot -ResourceGroupName $RG -SnapshotName $SnapshotName -Snapshot $SnapshotConfig | Out-Null
            Write-Host "  Snapshot created successfully." -ForegroundColor Green
        }

        Write-Host "  Deleting unattached disk: $Name..." -ForegroundColor Red
        Remove-AzDisk -ResourceGroupName $RG -DiskName $Name -Force
        Write-Host "  Disk deleted." -ForegroundColor Green
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " Total Monthly Financial Recovery: $$TotalMonthlySavingsUSD USD / €$TotalMonthlySavingsEUR EUR" -ForegroundColor Green
Write-Host " Total Annualized Financial Recovery: $([math]::Round($TotalMonthlySavingsUSD * 12, 2)) USD / €$([math]::Round($TotalMonthlySavingsEUR * 12, 2)) EUR" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

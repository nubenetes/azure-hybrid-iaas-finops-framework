<#
.SYNOPSIS
    FinOps Network Cost Saver: Deallocate Non-Production Azure Firewall Outside Business Hours.
.DESCRIPTION
    Azure Firewall Standard incurs a fixed $1.25/hr ($912/mo) fee even when carrying zero traffic.
    This script suspends/deallocates the Azure Firewall in non-production environments by unbinding
    its public IP configuration, dropping fixed billing to $0.00 while preserving all firewall
    rules and policy bindings.
.PARAMETER ResourceGroupName
    Resource group containing the firewall.
.PARAMETER FirewallName
    Name of the Azure Firewall.
.PARAMETER Action
    'Deallocate' (Stop billing) or 'Allocate' (Restore firewall).
.PARAMETER VNetName
    Name of the Hub VNet (required for Allocate).
.PARAMETER PublicIPName
    Name of the AzureFirewallSubnet Public IP (required for Allocate).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$FirewallName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Deallocate', 'Allocate')]
    [string]$Action,

    [Parameter(Mandatory = $false)]
    [string]$VNetName,

    [Parameter(Mandatory = $false)]
    [string]$PublicIPName
)

$ErrorActionPreference = 'Stop'

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " FinOps Azure Firewall Lifecycle Management: $Action" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$azFw = Get-AzFirewall -Name $FirewallName -ResourceGroupName $ResourceGroupName

if ($Action -eq 'Deallocate') {
    Write-Host "Deallocating Azure Firewall '$FirewallName' to stop hourly charges..." -ForegroundColor Yellow
    $azFw.Deallocate()
    Set-AzFirewall -AzureFirewall $azFw
    Write-Host "Firewall deallocated. Fixed billing paused (saving ~$1.25/hr)." -ForegroundColor Green
}
elseif ($Action -eq 'Allocate') {
    if (-not $VNetName -or -not $PublicIPName) {
        Write-Error "Parameters -VNetName and -PublicIPName are required when allocating the firewall."
    }
    Write-Host "Allocating Azure Firewall '$FirewallName'..." -ForegroundColor Yellow
    $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
    $pip = Get-AzPublicIpAddress -Name $PublicIPName -ResourceGroupName $ResourceGroupName
    
    $azFw.Allocate($vnet, $pip)
    Set-AzFirewall -AzureFirewall $azFw
    Write-Host "Firewall re-allocated and operating normally." -ForegroundColor Green
}

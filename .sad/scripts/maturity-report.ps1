#requires -Version 5.1
<#
.SYNOPSIS
  Maturity graduation-readiness card.
.DESCRIPTION
  Reads .sad/state/maturity-level.json, .sad/state/rollback-log.md, and
  .sad/state/satisfaction/<YYYY-MM>/*.md to compute graduation-readiness vs the
  thresholds in MATURITY.md.
.PARAMETER Json
  Emit structured JSON instead of pretty text.
.EXAMPLE
  .\maturity-report.ps1
.EXAMPLE
  .\maturity-report.ps1 -Json
#>
[CmdletBinding()]
param(
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Resolve-Path (Join-Path $scriptDir '..\..')
$stateFile = Join-Path $root '.sad\state\maturity-level.json'

if (-not (Test-Path $stateFile)) {
    Write-Error "Missing $stateFile. Copy the template from .sad/templates/ or run /sad-doctor."
    exit 1
}

$state = Get-Content $stateFile -Raw | ConvertFrom-Json
$currentLevel  = [int]$state.current_level
$levelStarted  = $state.level_started_on

# Feature counts: directories under specs/ ; "since level" uses LastWriteTime as proxy.
$featuresTotal = 0
$featuresSince = 0
$specsDir = Join-Path $root 'specs'
if (Test-Path $specsDir) {
    Get-ChildItem $specsDir -Directory | ForEach-Object {
        $featuresTotal++
        try {
            $created = $_.CreationTime
            if ([string]$levelStarted -ne '') {
                $start = [datetime]::ParseExact($levelStarted, 'yyyy-MM-dd', $null)
                if ($created -ge $start) { $featuresSince++ }
            }
        } catch { }
    }
}

# Rollbacks: rows in .sad/state/rollback-log.md starting with a YYYY-MM-DD date column.
$rollbacks = 0
$rollbackLog = Join-Path $root '.sad\state\rollback-log.md'
if (Test-Path $rollbackLog) {
    $rollbacks = (Select-String -Path $rollbackLog -Pattern '^\| \d{4}-\d{2}-\d{2} \|').Count
}

# Satisfaction: average Satisfaction % per tier across surveys in the most recent month.
$satAvg = $null
$tiersBelow = @()
$satRoot = Join-Path $root '.sad\state\satisfaction'
if (Test-Path $satRoot) {
    $months = Get-ChildItem $satRoot -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending
    if ($months.Count -gt 0) {
        $latest = $months[0]
        $files = Get-ChildItem $latest.FullName -Filter '*.md' -ErrorAction SilentlyContinue
        $total = 0; $count = 0
        foreach ($f in $files) {
            $body = Get-Content $f.FullName -Raw
            if ($body -match 'Satisfaction\s*%[^0-9]*([0-9]+)') {
                $pct = [int]$matches[1]
                $total += $pct
                $count++
                if ($pct -lt 80) {
                    $tier = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                    $tiersBelow += "$tier ($pct%)"
                }
            }
        }
        if ($count -gt 0) { $satAvg = [int][math]::Round($total / $count) }
    }
}

# Rollback rate.
$rbRate = 'n/a'
$rbOk   = 'n/a'
if ($featuresSince -gt 0) {
    $rate = [math]::Round($rollbacks / $featuresSince, 3)
    $rbRate = $rate.ToString('F3')
    $rbOk = if ($rate -le 0.05) { 'yes' } else { 'no' }
}
$satOk = 'n/a'
if ($null -ne $satAvg) { $satOk = if ($satAvg -ge 80) { 'yes' } else { 'no' } }

if ($Json) {
    [pscustomobject]@{
        current_level                          = $currentLevel
        level_started_on                       = $levelStarted
        features_total                         = $featuresTotal
        features_since_level_start             = $featuresSince
        rollbacks_since_level_start            = $rollbacks
        rollback_rate_per_feature              = $rbRate
        rollback_threshold_met                 = $rbOk
        stakeholder_satisfaction_avg_pct       = $satAvg
        stakeholder_satisfaction_threshold_met = $satOk
        tiers_below_threshold                  = ($tiersBelow -join ' ')
    } | ConvertTo-Json -Depth 4
} else {
    Write-Output "/sad-maturity-report"
    Write-Output ('-' * 60)
    Write-Output ("Current level         : {0}" -f $currentLevel)
    Write-Output ("Level started         : {0}" -f $levelStarted)
    Write-Output ("Features total        : {0}" -f $featuresTotal)
    Write-Output ("Features since level  : {0}" -f $featuresSince)
    Write-Output ("Rollbacks since level : {0}" -f $rollbacks)
    Write-Output ("Rollback rate         : {0} (threshold <= 0.05) -> {1}" -f $rbRate, $rbOk)
    if ($null -ne $satAvg) {
        Write-Output ("Satisfaction avg %    : {0}% (threshold >= 80) -> {1}" -f $satAvg, $satOk)
        if ($tiersBelow.Count -gt 0) {
            Write-Output ("Tiers below threshold : {0}" -f ($tiersBelow -join ' '))
        }
    } else {
        Write-Output "Satisfaction avg %    : no surveys recorded yet"
    }
}

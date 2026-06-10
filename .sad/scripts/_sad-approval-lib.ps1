# _sad-approval-lib.ps1 — shared walkthrough approval parsing (dot-sourced).

function Get-SadTierFile {
    param([string]$FeatDir, [string]$Tier)
    switch ($Tier) {
        { $_ -in @('non-technical','nt') }  { return Join-Path $FeatDir 'walkthroughs\non-technical.md' }
        { $_ -in @('semi-technical','st') } { return Join-Path $FeatDir 'walkthroughs\semi-technical.md' }
        { $_ -in @('technical','t') }       { return Join-Path $FeatDir 'walkthroughs\technical.md' }
        default { throw "Unknown tier: $Tier" }
    }
}

function Get-SadTierLabel {
    param([string]$Tier)
    switch ($Tier) {
        { $_ -in @('non-technical','nt') }  { return 'Non-technical' }
        { $_ -in @('semi-technical','st') } { return 'Semi-technical' }
        { $_ -in @('technical','t') }       { return 'Technical' }
        default { return $Tier }
    }
}

function Get-SadApprovalStatus {
    param([string]$File, [string]$Label)
    if (-not (Test-Path $File)) { return 'missing' }
    $body = Get-Content $File -Raw
    if ($body -match "(?im)^-\s*\[x\].*$([regex]::Escape($Label)).*reviewer") { return 'approved' }
    if ($body -match '(?i)approval status:\s*\*\*pending\*\*|\*\*status:\*\*\s*pending') { return 'pending' }
    if ($body -match "(?im)^-\s*\[ \].*$([regex]::Escape($Label)).*reviewer") { return 'unchecked' }
    return 'unchecked'
}

function Get-SadApprovalField {
    param([string]$File, [string]$Pattern)
    if (-not (Test-Path $File)) { return '' }
    $line = Select-String -Path $File -Pattern $Pattern -AllMatches | Select-Object -First 1
    if (-not $line) { return '' }
    return ($line.Line -replace '^[^:]*:\s*', '' -replace '^\*\*|\*\*$', '').Trim()
}

function Test-SadAllTiersApproved {
    param([string]$FeatDir)
    foreach ($tier in @('non-technical','semi-technical','technical')) {
        $label = Get-SadTierLabel $tier
        $file  = Get-SadTierFile $FeatDir $tier
        if ((Get-SadApprovalStatus $file $label) -ne 'approved') { return $false }
    }
    return $true
}

function Get-SadWalkthroughOverlapPct {
    param([string]$FileA, [string]$FileB)
    if (-not ((Test-Path $FileA) -and (Test-Path $FileB))) { return 0 }
    function Get-Words([string]$Path) {
        $text = (Get-Content $Path -Raw) -split '(?m)^## Approval' | Select-Object -First 1
        return [System.Collections.Generic.HashSet[string]]::new(
            [string[]]($text.ToLower() -split '[^a-z0-9]+' | Where-Object { $_ })
        )
    }
    $a = Get-Words $FileA
    $b = Get-Words $FileB
    $inter = @($a | Where-Object { $b.Contains($_) }).Count
    $union = $a.Count + $b.Count - $inter
    if ($union -le 0) { return 0 }
    return [int]([math]::Round(100 * $inter / $union))
}

function Get-SadTriageSize {
    param([string]$FeatDir)
    $f = Join-Path $FeatDir 'intent-size-triage.md'
    if (-not (Test-Path $f)) { return 'bounded' }
    $body = Get-Content $f -Raw
    if ($body -match '(?i)\*\*Size:\*\*\s*trivial|size:\s*trivial') { return 'trivial' }
    if ($body -match '(?i)\*\*Size:\*\*\s*strategic|size:\s*strategic') { return 'strategic' }
    return 'bounded'
}

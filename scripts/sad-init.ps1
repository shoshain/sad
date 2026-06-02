#requires -Version 5.1
<#
.SYNOPSIS
  Install SAD methodology into a target project.

.PARAMETER TargetDir
  The target project directory (must already exist).

.PARAMETER Minimal
  Install only the methodology core (.sad/ + LIFECYCLE.md, CHEATSHEET.md, QUICKSTART.md,
  MATURITY.md, ROLES.md, MANIFESTO.md, NOVEL.md, GLOSSARY.md, DAEMON.md) and the matching
  adapter pack. Skip commands/, agents/, hooks/, evals/, examples/, SAD_USER_GUIDE.md, and
  ATTRIBUTION.md.

.PARAMETER Persistent
  Wire SessionStart hooks (Claude Code) or alwaysApply:true rules (Cursor).
  No-op for adapters where persistence is the default (Aider, Codex, Windsurf).

.PARAMETER Schedule
  Install the 3 SAD scheduled commands as Windows Task Scheduler tasks (drift-scan daily,
  compound-refresh monthly, evolve-evals weekly) via scripts/sad-schedule.ps1.
  Per DAEMON.md §2 this is OS-scheduler-owned, not a SAD daemon.

.PARAMETER Assistant
  Force adapter: auto | claude-code | cursor | aider | codex | windsurf | none.

.PARAMETER Telemetry
  Opt-in adoption telemetry. Default: off.

.PARAMETER Force
  Overwrite existing files. Default: skip files that already exist.

.PARAMETER DryRun
  Print what would be done; write nothing.

.EXAMPLE
  .\scripts\sad-init.ps1 -TargetDir C:\path\to\my-project -Persistent

.EXAMPLE
  .\scripts\sad-init.ps1 -TargetDir C:\path\to\my-project -Minimal -Assistant cursor
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$TargetDir,

    [switch]$Minimal,
    [switch]$Persistent,
    [switch]$Schedule,
    [ValidateSet('auto','claude-code','cursor','aider','codex','windsurf','none')]
    [string]$Assistant = 'auto',
    [ValidateSet('on','off')]
    [string]$Telemetry = 'off',
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $TargetDir -PathType Container)) {
    Write-Error "Target directory does not exist: $TargetDir"
    exit 3
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sadRoot   = Resolve-Path (Join-Path $scriptDir '..')
$target    = Resolve-Path $TargetDir

function Say([string]$m) { Write-Output "[sad-init] $m" }

function New-Dir {
    param([string]$Path)
    if (Test-Path $Path) { return }
    if ($DryRun) { Say "DRY: mkdir $Path" } else { New-Item -ItemType Directory -Path $Path -Force | Out-Null }
}

function Detect-Assistant {
    if ($Assistant -ne 'auto') { return $Assistant }
    if (Test-Path (Join-Path $target '.claude'))   { return 'claude-code' }
    if (Test-Path (Join-Path $target '.cursor'))   { return 'cursor' }
    if (Test-Path (Join-Path $target '.windsurf')) { return 'windsurf' }
    if (Test-Path (Join-Path $target '.aider.conf.yml')) { return 'aider' }
    if (Test-Path (Join-Path $target '.aider.input.history')) { return 'aider' }
    if (Test-Path (Join-Path $target '.codex'))    { return 'codex' }
    if (Test-Path (Join-Path $target 'AGENTS.md')) { return 'codex' }
    return 'none'
}

$detected = Detect-Assistant
Say "detected assistant: $detected"

function Copy-Dir {
    param([string]$Src, [string]$Dst)
    if (-not (Test-Path $Src -PathType Container)) { return }
    if (-not (Test-Path $Dst)) {
        if ($DryRun) { Say "DRY: mkdir $Dst" } else { New-Item -ItemType Directory -Path $Dst -Force | Out-Null }
    }
    Get-ChildItem $Src -Recurse -File | ForEach-Object {
        $rel  = $_.FullName.Substring($Src.Length).TrimStart('\','/')
        $dest = Join-Path $Dst $rel
        if ((Test-Path $dest) -and -not $Force) { return }
        $destDir = Split-Path -Parent $dest
        if (-not (Test-Path $destDir)) {
            if ($DryRun) { Say "DRY: mkdir $destDir" } else { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        }
        if ($DryRun) { Say "DRY: cp $rel" } else { Copy-Item -Path $_.FullName -Destination $dest -Force }
    }
}

function Copy-One {
    param([string]$Src, [string]$Dst)
    if (-not (Test-Path $Src)) { return }
    if ((Test-Path $Dst) -and -not $Force) { Say "skip (exists): $($Dst.Substring($target.Path.Length).TrimStart('\','/'))"; return }
    $destDir = Split-Path -Parent $Dst
    if (-not (Test-Path $destDir)) {
        if ($DryRun) { Say "DRY: mkdir $destDir" } else { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    }
    if ($DryRun) { Say "DRY: cp $Src -> $Dst" } else { Copy-Item -Path $Src -Destination $Dst -Force }
}

Say "installing methodology core into $target"
Copy-Dir  (Join-Path $sadRoot '.sad')           (Join-Path $target '.sad')
Copy-One  (Join-Path $sadRoot 'LIFECYCLE.md')   (Join-Path $target 'LIFECYCLE.md')
Copy-One  (Join-Path $sadRoot 'CHEATSHEET.md')  (Join-Path $target 'CHEATSHEET.md')
Copy-One  (Join-Path $sadRoot 'QUICKSTART.md')  (Join-Path $target 'QUICKSTART.md')
Copy-One  (Join-Path $sadRoot 'MATURITY.md')    (Join-Path $target 'MATURITY.md')
Copy-One  (Join-Path $sadRoot 'ROLES.md')       (Join-Path $target 'ROLES.md')
Copy-One  (Join-Path $sadRoot 'MANIFESTO.md')   (Join-Path $target 'MANIFESTO.md')
Copy-One  (Join-Path $sadRoot 'NOVEL.md')       (Join-Path $target 'NOVEL.md')
Copy-One  (Join-Path $sadRoot 'GLOSSARY.md')    (Join-Path $target 'GLOSSARY.md')
Copy-One  (Join-Path $sadRoot 'DAEMON.md')      (Join-Path $target 'DAEMON.md')

if (-not $Minimal) {
    Copy-Dir (Join-Path $sadRoot 'commands') (Join-Path $target 'commands')
    Copy-Dir (Join-Path $sadRoot 'agents')   (Join-Path $target 'agents')
    Copy-Dir (Join-Path $sadRoot 'hooks')    (Join-Path $target 'hooks')
    Copy-Dir (Join-Path $sadRoot 'evals')    (Join-Path $target 'evals')
    Copy-Dir (Join-Path $sadRoot 'examples') (Join-Path $target 'examples')
    Copy-One (Join-Path $sadRoot 'SAD_USER_GUIDE.md') (Join-Path $target 'SAD_USER_GUIDE.md')
    Copy-One (Join-Path $sadRoot 'ATTRIBUTION.md')    (Join-Path $target 'ATTRIBUTION.md')
}

New-Dir (Join-Path $target 'specs')

function Apply-Adapter {
    param([string]$Name, [bool]$Persist)
    if ($Name -eq 'none') {
        Copy-One (Join-Path $sadRoot 'adapters\codex\AGENTS.md') (Join-Path $target 'AGENTS.md')
        return
    }
    $apath = Join-Path $sadRoot "adapters\$Name"
    if (-not (Test-Path $apath)) { Say "no adapter: $Name"; return }

    switch ($Name) {
        'claude-code' {
            New-Dir (Join-Path $target '.claude\commands')
            New-Dir (Join-Path $target '.claude\skills\sad')
            # Prefer Windows-flavored settings (PowerShell hook commands) when shipped.
            $settingsSrc = if ($Persist) { 'settings.windows.persistent.json' } else { 'settings.windows.json' }
            if (-not (Test-Path (Join-Path $apath $settingsSrc))) {
                $settingsSrc = if ($Persist) { 'settings.persistent.json' } else { 'settings.json' }
            }
            Copy-One (Join-Path $apath $settingsSrc)            (Join-Path $target '.claude\settings.json')
            Copy-One (Join-Path $apath 'skills\sad\SKILL.md')   (Join-Path $target '.claude\skills\sad\SKILL.md')
            $adapterCmdDir = Join-Path $apath 'commands'
            Get-ChildItem -Path (Join-Path $sadRoot 'commands') -Filter 'sad-*.md' -ErrorAction SilentlyContinue | ForEach-Object {
                $dst = Join-Path $target ".claude\commands\$($_.Name)"
                if ((Test-Path $dst) -and -not $Force) { return }
                $override = Join-Path $adapterCmdDir $_.Name
                if (Test-Path $override) {
                    # Adapter ships an explicit pointer override for this command — copy verbatim.
                    if ($DryRun) { Say "DRY: cp override $override -> $dst" } else { Copy-Item -Path $override -Destination $dst -Force }
                } else {
                    $content = "# $($_.BaseName)`n`nClaude Code slash-command pointer. Canonical prompt lives at ``commands/$($_.Name)`` in this repo. Read it and follow its 'Your task' / 'Discipline' sections exactly.`n"
                    if ($DryRun) { Say "DRY: write $dst" } else { Set-Content -Path $dst -Value $content -Encoding utf8 }
                }
            }
            Copy-One (Join-Path $sadRoot 'adapters\codex\AGENTS.md') (Join-Path $target 'AGENTS.md')
        }
        'cursor' {
            New-Dir (Join-Path $target '.cursor\rules')
            New-Dir (Join-Path $target '.cursor\commands')
            $ruleSrc = if ($Persist) { 'sad-routing.persistent.mdc' } else { 'sad-routing.mdc' }
            Copy-One (Join-Path $apath $ruleSrc) (Join-Path $target '.cursor\rules\sad-routing.mdc')
            Get-ChildItem -Path (Join-Path $sadRoot 'commands') -Filter 'sad-*.md' -ErrorAction SilentlyContinue | ForEach-Object {
                Copy-One $_.FullName (Join-Path $target ".cursor\commands\$($_.Name)")
            }
            Copy-One (Join-Path $sadRoot 'adapters\codex\AGENTS.md') (Join-Path $target 'AGENTS.md')
        }
        'aider' {
            Copy-One (Join-Path $apath 'CONVENTIONS.md')          (Join-Path $target 'CONVENTIONS.md')
            Copy-One (Join-Path $apath '.aider.conf.yml.snippet') (Join-Path $target '.aider.conf.yml.snippet')
            Copy-One (Join-Path $sadRoot 'adapters\codex\AGENTS.md') (Join-Path $target 'AGENTS.md')
        }
        'codex' {
            Copy-One (Join-Path $apath 'AGENTS.md') (Join-Path $target 'AGENTS.md')
        }
        'windsurf' {
            New-Dir (Join-Path $target '.windsurf\rules')
            Copy-One (Join-Path $apath 'sad-routing.md') (Join-Path $target '.windsurf\rules\sad-routing.md')
            Copy-One (Join-Path $sadRoot 'adapters\codex\AGENTS.md') (Join-Path $target 'AGENTS.md')
        }
        default { Say "unknown adapter: $Name" }
    }
}

Apply-Adapter -Name $detected -Persist:$Persistent

if ($Telemetry -eq 'on') {
    $telPath = Join-Path $target '.sad\state\telemetry.json'
    $payload = @{ telemetry='opt-in'; installed=(Get-Date).ToUniversalTime().ToString('o') } | ConvertTo-Json -Compress
    if ($DryRun) { Say "DRY: write telemetry $telPath" } else { Set-Content -Path $telPath -Value $payload -Encoding utf8 }
}

$doctor = Join-Path $target '.sad\scripts\doctor.ps1'
if (Test-Path $doctor) {
    Say 'running /sad-doctor on the freshly installed target'
    try {
        Push-Location $target
        & $doctor
    } catch {
        Say "doctor reported findings (this is normal on a fresh install)"
    } finally {
        Pop-Location
    }
}

if ($Schedule) {
    $schedScript = Join-Path $sadRoot 'scripts\sad-schedule.ps1'
    if (Test-Path $schedScript) {
        Say 'installing OS scheduled tasks (Task Scheduler) for SAD cadence commands'
        try {
            if ($DryRun) {
                & $schedScript -Action install -TargetDir $target -DryRun
            } else {
                & $schedScript -Action install -TargetDir $target
            }
        } catch {
            Say "schedule install reported an issue: $($_.Exception.Message)"
        }
    } else {
        Say 'WARN: -Schedule requested but scripts/sad-schedule.ps1 not found in kit'
    }
}

Say "done. target: $target ; adapter: $detected ; persistent: $Persistent ; minimal: $Minimal ; schedule: $Schedule"
Say "next: cd $target ; open QUICKSTART.md  (or run /sad-next in your AI assistant)"

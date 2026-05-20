#requires -Version 5.1
<#
.SYNOPSIS
  Scaffold specs/<prefix>-<slug>/ from SAD templates.
.EXAMPLE
  .\create-feature.ps1 001 my-feature-name
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Prefix,
    [Parameter(Mandatory=$true, Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$SlugParts
)

$ErrorActionPreference = 'Stop'

$slug = ($SlugParts -join '-').ToLowerInvariant() -replace '\s+', '-'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Resolve-Path (Join-Path $scriptDir '..\..')
$feat      = Join-Path $root "specs\$Prefix-$slug"
$tpl       = Join-Path $root '.sad\templates'

foreach ($sub in @('walkthroughs','demo','stories','evals','contracts')) {
    New-Item -ItemType Directory -Path (Join-Path $feat $sub) -Force | Out-Null
}

function Copy-Template {
    param([string]$Name, [string]$Dest)
    $src = Join-Path $tpl $Name
    if (-not (Test-Path $src)) {
        Write-Error "Template missing: $src"
    }
    Copy-Item $src $Dest -Force
}

Copy-Template 'feature.spec.md'                  (Join-Path $feat 'feature.spec.md')
Copy-Template 'feature.plan.md'                  (Join-Path $feat 'feature.plan.md')
Copy-Template 'tasks.md'                         (Join-Path $feat 'tasks.md')
Copy-Template 'impact-forecast.md'               (Join-Path $feat 'impact-forecast.md')
Copy-Template 'reconciliation.md'                (Join-Path $feat 'reconciliation.md')
Copy-Template 'walkthrough-non-technical.md'     (Join-Path $feat 'walkthroughs\non-technical.md')
Copy-Template 'walkthrough-semi-technical.md'    (Join-Path $feat 'walkthroughs\semi-technical.md')
Copy-Template 'walkthrough-technical.md'         (Join-Path $feat 'walkthroughs\technical.md')

Write-Output "Scaffolded $feat"

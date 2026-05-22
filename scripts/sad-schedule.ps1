#requires -Version 5.1
<#
.SYNOPSIS
  Install or remove Windows Task Scheduler tasks for SAD's scheduled commands.

.DESCRIPTION
  Per DAEMON.md §2: SAD does not run a long-lived daemon. Cadence work is owned
  by the user's existing scheduler. This script registers (or unregisters)
  Scheduled Tasks for the three SAD cadence commands.

  Tasks installed (under the folder \SAD\<target-name>):
    SAD-DriftScan       — daily 09:00 — runs .sad/scripts/drift-scan.ps1
    SAD-CompoundRefresh — monthly 1st 09:00 — writes a reminder to scheduled-reminders.log
    SAD-EvolveEvals     — weekly Monday 09:00 — writes a reminder to scheduled-reminders.log

  Why reminders for the last two: those commands do meaningful work *inside* the
  AI assistant session (curating lessons, evolving evals). A scheduled task cannot
  substitute for that -- it nudges the user to invoke the slash command.
  /sad-spec-drift-scan has a real script and can run unattended.

.PARAMETER Action
  install | uninstall | list

.PARAMETER TargetDir
  The project directory (the one containing .sad/) the schedule entries should target.

.PARAMETER DryRun
  Print the actions instead of taking them.

.EXAMPLE
  .\scripts\sad-schedule.ps1 -Action install   -TargetDir C:\path\to\project
  .\scripts\sad-schedule.ps1 -Action uninstall -TargetDir C:\path\to\project
  .\scripts\sad-schedule.ps1 -Action list      -TargetDir C:\path\to\project

.NOTES
  Uses Register-ScheduledTask, which does not require elevation for tasks that run
  as the current user. Tasks are placed under the \SAD\<safe-target-name> folder so
  multiple projects can coexist and uninstall is deterministic.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('install','uninstall','list')]
    [string]$Action,

    [Parameter(Mandatory=$true)]
    [string]$TargetDir,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $TargetDir -PathType Container)) {
    Write-Error "Target directory does not exist: $TargetDir"
    exit 3
}
$target = (Resolve-Path $TargetDir).Path
$safeName = ($target -replace '[\\/:]','_').Trim('_')
$folder   = "\SAD\$safeName"
$log      = Join-Path $target '.sad\state\scheduled-reminders.log'

$tasks = @(
    @{
        Name    = 'SAD-DriftScan'
        Trigger = { New-ScheduledTaskTrigger -Daily -At 9am }
        Action  = (New-ScheduledTaskAction -Execute 'powershell.exe' `
                     -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$target\.sad\scripts\drift-scan.ps1`"" `
                     -WorkingDirectory $target)
    },
    @{
        Name    = 'SAD-CompoundRefresh'
        Trigger = { New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9am }
        Action  = (New-ScheduledTaskAction -Execute 'powershell.exe' `
                     -Argument "-NoProfile -Command `"Add-Content -Path '$log' -Value ('[' + (Get-Date -Format o) + '] SAD reminder: run /sad-compound-refresh in $target')`"" `
                     -WorkingDirectory $target)
    },
    @{
        Name    = 'SAD-EvolveEvals'
        Trigger = { New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9am }
        Action  = (New-ScheduledTaskAction -Execute 'powershell.exe' `
                     -Argument "-NoProfile -Command `"Add-Content -Path '$log' -Value ('[' + (Get-Date -Format o) + '] SAD reminder: run /sad-evolve-evals in $target')`"" `
                     -WorkingDirectory $target)
    }
)

function Get-ExistingTasks {
    Get-ScheduledTask -TaskPath "$folder\" -ErrorAction SilentlyContinue
}

switch ($Action) {
    'list' {
        $existing = Get-ExistingTasks
        if (-not $existing) {
            Write-Output "(no SAD scheduled tasks for $target)"
        } else {
            $existing | ForEach-Object { Write-Output "$($_.TaskPath)$($_.TaskName)" }
        }
    }

    'install' {
        if ($DryRun) {
            Write-Output "DRY: would register the following tasks under $folder :"
            $tasks | ForEach-Object { Write-Output "  - $($_.Name)" }
            return
        }
        # Remove any pre-existing tasks in this folder first, so install is idempotent.
        Get-ExistingTasks | ForEach-Object {
            Unregister-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -Confirm:$false
        }
        foreach ($t in $tasks) {
            $trigger = & $t.Trigger
            Register-ScheduledTask `
                -TaskName  $t.Name `
                -TaskPath  $folder `
                -Action    $t.Action `
                -Trigger   $trigger `
                -Description "SAD scheduled task for $target. Installed by sad-schedule.ps1." `
                -RunLevel  Limited `
                -Force | Out-Null
            Write-Output "Registered: $folder\$($t.Name)"
        }
        Write-Output "Done. Tasks visible in Task Scheduler under $folder."
    }

    'uninstall' {
        $existing = Get-ExistingTasks
        if (-not $existing) {
            Write-Output "(no SAD scheduled tasks for $target)"
            return
        }
        if ($DryRun) {
            Write-Output "DRY: would unregister:"
            $existing | ForEach-Object { Write-Output "  - $($_.TaskPath)$($_.TaskName)" }
            return
        }
        foreach ($t in $existing) {
            Unregister-ScheduledTask -TaskName $t.TaskName -TaskPath $t.TaskPath -Confirm:$false
            Write-Output "Removed: $($t.TaskPath)$($t.TaskName)"
        }
    }
}

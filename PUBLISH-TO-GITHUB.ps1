# Publishes the seeded local DexRoboKnix repos to the Dex-RoboKnix GitHub org.
#
# Prerequisites:
# - GitHub CLI installed.
# - `gh auth status` succeeds.
# - Authenticated account can create repos in Dex-RoboKnix.
#
# This script assumes the local repos have already been created and committed.

$org = "Dex-RoboKnix"
$base = "C:\Users\Dan\Documents\Projects\DEXROBOKNIX"

$repos = @(
    [pscustomobject]@{
        Name = "Dex_RoboKnix"
        Visibility = "public"
        Description = "DexRoboKnix parent organisation docs, layer map, and project status"
        Path = "$base\l1"
    },
    [pscustomobject]@{
        Name = "dexspine-core"
        Visibility = "public"
        Description = "DexSpine - deterministic cognitive infrastructure for LLM collaboration (Core / Open Source)"
        Path = "$base\dexspine\core"
    },
    [pscustomobject]@{
        Name = "dexspine-enterprise"
        Visibility = "private"
        Description = "DexSpine Enterprise - private commercial edition"
        Path = "$base\dexspine\enterprise"
    },
    [pscustomobject]@{
        Name = "dexcli-core"
        Visibility = "public"
        Description = "DexCLI - terminal agent team manager, L3 under DexSpine (Core / Open Source)"
        Path = "$base\dexspine\dexcli\core"
    },
    [pscustomobject]@{
        Name = "dexcli-enterprise"
        Visibility = "private"
        Description = "DexCLI Enterprise - private commercial edition"
        Path = "$base\dexspine\dexcli\enterprise"
    },
    [pscustomobject]@{
        Name = "shadowos-core"
        Visibility = "public"
        Description = "ShadowOS - local-first browser desktop environment, L2 platform (Core / Open Source)"
        Path = "$base\ShadowOS\core"
    },
    [pscustomobject]@{
        Name = "shadowos-enterprise"
        Visibility = "private"
        Description = "ShadowOS Enterprise - private commercial edition"
        Path = "$base\ShadowOS\enterprise"
    },
    [pscustomobject]@{
        Name = "ade-core"
        Visibility = "public"
        Description = "ADE - Agent Desktop Environment, MCP agent layer for ShadowOS (Core / Open Source)"
        Path = "$base\ShadowOS\Agent Desktop Environment\ade-core"
    },
    [pscustomobject]@{
        Name = "ade-enterprise"
        Visibility = "private"
        Description = "ADE Enterprise - private commercial edition"
        Path = "$base\ShadowOS\Agent Desktop Environment\ade-enterprise"
    }
)

function Test-GitHubRepoExists {
    param([string]$FullName)
    gh repo view $FullName *> $null
    return $LASTEXITCODE -eq 0
}

function Ensure-Remote {
    param(
        [string]$Path,
        [string]$Url
    )
    git -C $Path remote get-url origin *> $null
    if ($LASTEXITCODE -eq 0) {
        git -C $Path remote set-url origin $Url
    } else {
        git -C $Path remote add origin $Url
    }
}

gh auth status
if ($LASTEXITCODE -ne 0) {
    throw "GitHub CLI is not authenticated."
}

foreach ($repo in $repos) {
    if (-not (Test-Path -LiteralPath $repo.Path)) {
        throw "Missing local repo path: $($repo.Path)"
    }
    if (-not (Test-Path -LiteralPath (Join-Path $repo.Path ".git"))) {
        throw "Path is not a git repo: $($repo.Path)"
    }

    $fullName = "$org/$($repo.Name)"
    $repoUrl = "https://github.com/$fullName.git"
    $visFlag = if ($repo.Visibility -eq "public") { "--public" } else { "--private" }

    if (Test-GitHubRepoExists -FullName $fullName) {
        Write-Host "EXISTS $fullName" -ForegroundColor Yellow
    } else {
        gh repo create $fullName $visFlag --description $repo.Description
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create GitHub repo: $fullName"
        }
        Write-Host "CREATED $fullName" -ForegroundColor Green
    }

    Ensure-Remote -Path $repo.Path -Url $repoUrl
    git -C $repo.Path push -u origin main
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to push $fullName"
    }
}

Write-Host "Publish complete." -ForegroundColor Cyan


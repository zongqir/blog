param(
  [Parameter(Mandatory = $true)]
  [string]$Title,
  [string]$Description = "TODO: add summary",
  [string]$Date,
  [string]$Updated,
  [string[]]$Tags = @(),
  [string]$Slug
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Quote-Yaml([string]$Text) {
  return "'" + ($Text -replace "'", "''") + "'"
}

function Parse-DateOrDefault([string]$InputValue, [DateTimeOffset]$DefaultValue) {
  if ([string]::IsNullOrWhiteSpace($InputValue)) {
    return $DefaultValue
  }

  try {
    return [DateTimeOffset]::Parse($InputValue)
  }
  catch {
    throw "Cannot parse date: $InputValue. Use format like '2025-01-18 22:30:00 +0800'."
  }
}

$now = [DateTimeOffset]::Now
$published = Parse-DateOrDefault -InputValue $Date -DefaultValue $now
$edited = Parse-DateOrDefault -InputValue $Updated -DefaultValue $published

if ([string]::IsNullOrWhiteSpace($Slug)) {
  $Slug = $Title.ToLowerInvariant()
  $Slug = $Slug -replace "[^a-z0-9]+", "-"
  $Slug = $Slug -replace "^-+", ""
  $Slug = $Slug -replace "-+$", ""

  if ([string]::IsNullOrWhiteSpace($Slug)) {
    $Slug = "post-" + $now.ToString("yyyyMMddHHmmss")
  }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$postsDir = Join-Path $repoRoot "_posts"
if (-not (Test-Path $postsDir)) {
  New-Item -ItemType Directory -Path $postsDir | Out-Null
}

$fileName = "{0}-{1}.md" -f $published.ToString("yyyy-MM-dd"), $Slug
$target = Join-Path $postsDir $fileName
if (Test-Path $target) {
  throw "Post already exists: $target"
}

$lines = @(
  "---",
  "title: $(Quote-Yaml $Title)",
  "description: $(Quote-Yaml $Description)",
  "date: $($published.ToString("yyyy-MM-dd HH:mm:ss zzz"))",
  "updated: $($edited.ToString("yyyy-MM-dd HH:mm:ss zzz"))"
)

if ($Tags.Count -gt 0) {
  $lines += "tags:"
  foreach ($tag in $Tags) {
    if (-not [string]::IsNullOrWhiteSpace($tag)) {
      $lines += "  - $(Quote-Yaml $tag)"
    }
  }
}

$lines += @(
  "---",
  "",
  "Write your content here.",
  ""
)

$lines | Set-Content -Path $target -Encoding UTF8
Write-Output "Created: $target"


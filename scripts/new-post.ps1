param(
  [Parameter(Mandatory = $true)]
  [string]$Title,
  [string]$Description = "TODO: add summary",
  [string]$Date,
  [string]$Updated,
  [string[]]$Tags = @(),
  [string]$Slug,
  [switch]$NoAutoMeta,
  [switch]$DryRun
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

function Normalize-Text([string]$Text) {
  if ([string]::IsNullOrWhiteSpace($Text)) {
    return ""
  }
  return $Text.ToLowerInvariant()
}

function Add-UniqueTag([System.Collections.Generic.List[string]]$TagList, [string]$Tag) {
  if ([string]::IsNullOrWhiteSpace($Tag)) {
    return
  }
  if (-not $TagList.Contains($Tag)) {
    $TagList.Add($Tag)
  }
}

function U([string]$EscapedText) {
  return [Regex]::Unescape($EscapedText)
}

$TAG_I18N = U '\u56fd\u9645\u5316'
$TAG_ARCH = U '\u67b6\u6784\u8bbe\u8ba1'
$TAG_GOV = U '\u5de5\u7a0b\u6cbb\u7406'
$TAG_SRE = 'SRE'
$TAG_PERF = U '\u6027\u80fd\u4f18\u5316'
$TAG_LINUX = 'Linux'
$TAG_TOB = 'ToB'

$SERIES_GLOBAL = U '\u5168\u7403\u5316\u5de5\u7a0b\u6cbb\u7406'
$SERIES_SRE = U 'SRE \u6545\u969c\u5b9e\u6218'
$SERIES_GOV = U '\u5de5\u7a0b\u6cbb\u7406\u4f53\u7cfb'

function Match-Pattern([string]$Text, [string]$Pattern) {
  if ([string]::IsNullOrWhiteSpace($Text)) {
    return $false
  }
  return [Regex]::IsMatch($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

function Get-AutoTags([string]$TitleText, [string]$DescText) {
  $text = (Normalize-Text $TitleText) + " " + (Normalize-Text $DescText)
  $rules = @(
    @{ Tag = $TAG_I18N; Pattern = '\u56fd\u9645\u5316|i18n|locale|\u591a\u8bed\u8a00|\u65f6\u533a|utc' },
    @{ Tag = $TAG_ARCH; Pattern = '\u67b6\u6784|ddd|\u9886\u57df|\u72b6\u6001\u673a|\u9002\u914d\u5668|\u8fb9\u754c|\u6f14\u8fdb' },
    @{ Tag = $TAG_GOV; Pattern = '\u6cbb\u7406|\u89c4\u8303|\u95e8\u7981|checklist|\u6d41\u7a0b|\u6807\u51c6\u5316|\u81ea\u52a8\u5316' },
    @{ Tag = $TAG_SRE; Pattern = '\u6545\u969c|\u544a\u8b66|\u76d1\u63a7|\u53ef\u7528\u6027|\u7a33\u5b9a\u6027|\u6062\u590d|\u5bb9\u91cf|sre' },
    @{ Tag = $TAG_PERF; Pattern = '\u6027\u80fd|\u5ef6\u8fdf|\u541e\u5410|cpu|\u5185\u5b58|io|gc|\u538b\u6d4b' },
    @{ Tag = $TAG_LINUX; Pattern = 'linux|top|vmstat|pidstat|iostat|\u5185\u6838|\u7cfb\u7edf\u8c03\u7528' },
    @{ Tag = $TAG_TOB; Pattern = 'tob|b\u7aef|\u4f01\u4e1a\u5ba2\u6237|saas' }
  )

  $result = New-Object 'System.Collections.Generic.List[string]'
  foreach ($rule in $rules) {
    if (Match-Pattern -Text $text -Pattern $rule.Pattern) {
      Add-UniqueTag -TagList $result -Tag $rule.Tag
    }
  }

  if ($result.Count -eq 0) {
    Add-UniqueTag -TagList $result -Tag $TAG_GOV
  }

  if ($result.Count -gt 5) {
    return $result.GetRange(0, 5).ToArray()
  }

  return $result.ToArray()
}

function Get-AutoSeries([string[]]$TagList) {
  if ($TagList -contains $TAG_I18N) { return $SERIES_GLOBAL }
  if (($TagList -contains $TAG_SRE) -or ($TagList -contains $TAG_LINUX)) { return $SERIES_SRE }
  if (($TagList -contains $TAG_ARCH) -or ($TagList -contains $TAG_GOV)) { return $SERIES_GOV }
  return ""
}

function Has-SeriesSignal([string[]]$TagList, [string]$TitleText, [string]$DescText, [bool]$PreferTagOnly) {
  if (($TagList -contains $TAG_I18N) -or
      ($TagList -contains $TAG_SRE) -or
      ($TagList -contains $TAG_LINUX) -or
      ($TagList -contains $TAG_ARCH)) {
    return $true
  }

  if ($TagList -contains $TAG_GOV) {
    if ($PreferTagOnly) {
      return $true
    }

    $text = (Normalize-Text $TitleText) + " " + (Normalize-Text $DescText)
    return Match-Pattern -Text $text -Pattern '\u6cbb\u7406|\u89c4\u8303|\u95e8\u7981|checklist|\u6d41\u7a0b|\u6807\u51c6\u5316|\u81ea\u52a8\u5316'
  }

  return $false
}

function Get-SeriesIntent([string]$SeriesName) {
  if ($SeriesName -eq $SERIES_GLOBAL) {
    return U '\u6c89\u6dc0\u591a\u56fd\u5bb6\u4e1a\u52a1\u6269\u5f20\u4e2d\u7684\u5168\u7403\u5316\u5de5\u7a0b\u6cbb\u7406\u65b9\u6cd5\u8bba\u3002'
  }
  if ($SeriesName -eq $SERIES_SRE) {
    return U '\u6c89\u6dc0\u6545\u969c\u53d1\u73b0\u3001\u5b9a\u4f4d\u3001\u6062\u590d\u4e0e\u7a33\u5b9a\u6027\u6cbb\u7406\u7684\u5b9e\u6218\u95ed\u73af\u3002'
  }
  if ($SeriesName -eq $SERIES_GOV) {
    return U '\u6c89\u6dc0\u4ece\u67b6\u6784\u8bbe\u8ba1\u5230\u5de5\u7a0b\u89c4\u8303\u7684\u4f53\u7cfb\u5316\u6cbb\u7406\u8def\u5f84\u3002'
  }
  return U '\u6c89\u6dc0\u8be5\u4e3b\u9898\u4e0b\u53ef\u590d\u7528\u7684\u5de5\u7a0b\u65b9\u6cd5\u4e0e\u8fdb\u9636\u8def\u5f84\u3002'
}

function Get-SeriesPart([string]$PostsDirectory, [string]$SeriesName) {
  if ([string]::IsNullOrWhiteSpace($SeriesName)) {
    return 0
  }

  if (-not (Test-Path $PostsDirectory)) {
    return 1
  }

  $count = 0
  $files = Get-ChildItem -Path $PostsDirectory -Filter "*.md" -File -ErrorAction SilentlyContinue
  foreach ($file in $files) {
    $seriesLine = Select-String -Path $file.FullName -Pattern '^\s*series:\s*' -Encoding UTF8 | Select-Object -First 1
    if ($null -eq $seriesLine) {
      continue
    }

    $rawValue = ([string]$seriesLine.Line) -replace '^\s*series:\s*', ''
    $rawValue = $rawValue.Trim()
    $rawValue = $rawValue.Trim("'")
    $rawValue = $rawValue.Trim('"')

    if ($rawValue -eq $SeriesName) {
      $count += 1
    }
  }

  return ($count + 1)
}

function Get-AutoHotMeta([string[]]$TagList, [string]$TitleText, [string]$DescText, [bool]$PreferTagOnly) {
  $hot = $false
  $rank = 0

  if ($TagList -contains $TAG_ARCH) {
    $hot = $true
    $rank = 10
  }
  elseif (($TagList -contains $TAG_GOV) -and (Has-SeriesSignal -TagList $TagList -TitleText $TitleText -DescText $DescText -PreferTagOnly $PreferTagOnly)) {
    $hot = $true
    $rank = 15
  }
  elseif ($TagList -contains $TAG_I18N) {
    $hot = $true
    $rank = 20
  }
  elseif ($TagList -contains $TAG_SRE) {
    $hot = $true
    $rank = 30
  }
  elseif ($TagList -contains $TAG_PERF) {
    $hot = $true
    $rank = 40
  }

  return @{
    Hot = $hot
    Rank = $rank
  }
}

$now = [DateTimeOffset]::Now
$published = Parse-DateOrDefault -InputValue $Date -DefaultValue $now
$edited = Parse-DateOrDefault -InputValue $Updated -DefaultValue $published
$repoRoot = Split-Path -Parent $PSScriptRoot
$postsDir = Join-Path $repoRoot "_posts"
if (-not (Test-Path $postsDir)) {
  New-Item -ItemType Directory -Path $postsDir | Out-Null
}

$resolvedTags = New-Object 'System.Collections.Generic.List[string]'
$hasManualTagsInput = $Tags.Count -gt 0
foreach ($tag in $Tags) {
  if (-not [string]::IsNullOrWhiteSpace($tag)) {
    Add-UniqueTag -TagList $resolvedTags -Tag $tag.Trim()
  }
}

if (($resolvedTags.Count -eq 0) -and (-not $NoAutoMeta)) {
  $autoTags = Get-AutoTags -TitleText $Title -DescText $Description
  foreach ($tag in $autoTags) {
    Add-UniqueTag -TagList $resolvedTags -Tag $tag
  }
}

if ($resolvedTags.Count -eq 0) {
  Add-UniqueTag -TagList $resolvedTags -Tag $TAG_GOV
}

$series = ""
$seriesPart = 0
$seriesIntent = ""
$seriesBuildable = $false
$hot = $false
$hotRank = 0
if (-not $NoAutoMeta) {
  $seriesSignal = Has-SeriesSignal -TagList $resolvedTags.ToArray() -TitleText $Title -DescText $Description -PreferTagOnly $hasManualTagsInput
  if ($seriesSignal) {
    $series = Get-AutoSeries -TagList $resolvedTags.ToArray()
  }

  if (-not [string]::IsNullOrWhiteSpace($series)) {
    $seriesPart = Get-SeriesPart -PostsDirectory $postsDir -SeriesName $series
    $seriesIntent = Get-SeriesIntent -SeriesName $series
    $seriesBuildable = $true
  }

  $hotMeta = Get-AutoHotMeta -TagList $resolvedTags.ToArray() -TitleText $Title -DescText $Description -PreferTagOnly $hasManualTagsInput
  $hot = [bool]$hotMeta.Hot
  $hotRank = [int]$hotMeta.Rank
}

if ([string]::IsNullOrWhiteSpace($Slug)) {
  $Slug = $Title.ToLowerInvariant()
  $Slug = $Slug -replace "[^a-z0-9]+", "-"
  $Slug = $Slug -replace "^-+", ""
  $Slug = $Slug -replace "-+$", ""

  if ([string]::IsNullOrWhiteSpace($Slug)) {
    $Slug = "post-" + $now.ToString("yyyyMMddHHmmss")
  }
}

$fileName = "{0}-{1}.md" -f $published.ToString("yyyy-MM-dd"), $Slug
$target = Join-Path $postsDir $fileName
if ((-not $DryRun) -and (Test-Path $target)) {
  throw "Post already exists: $target"
}

$lines = @(
  "---",
  "title: $(Quote-Yaml $Title)",
  "description: $(Quote-Yaml $Description)",
  "date: $($published.ToString("yyyy-MM-dd HH:mm:ss zzz"))",
  "updated: $($edited.ToString("yyyy-MM-dd HH:mm:ss zzz"))"
)

if ($resolvedTags.Count -gt 0) {
  $lines += "tags:"
  foreach ($tag in $resolvedTags) {
    $lines += "  - $(Quote-Yaml $tag)"
  }
}

if (-not $NoAutoMeta) {
  if (-not [string]::IsNullOrWhiteSpace($series)) {
    $lines += "series: $(Quote-Yaml $series)"
    if ($seriesPart -gt 0) {
      $lines += "series_part: $seriesPart"
    }
    if (-not [string]::IsNullOrWhiteSpace($seriesIntent)) {
      $lines += "series_intent: $(Quote-Yaml $seriesIntent)"
    }
    $lines += "series_buildable: true"
  }
  else {
    $lines += "series_buildable: false"
  }
  $lines += "hot: " + ($(if ($hot) { "true" } else { "false" }))
  if ($hot -and $hotRank -gt 0) {
    $lines += "hot_rank: $hotRank"
  }
  $lines += "related_auto: true"
}

$lines += @(
  "---",
  "",
  "Write your content here.",
  ""
)

if ($DryRun) {
  Write-Output "[DryRun] target: $target"
  $lines | ForEach-Object { $_ }
  return
}

$lines | Set-Content -Path $target -Encoding UTF8
Write-Output "Created: $target"
Write-Output ("Auto tags: " + ($resolvedTags -join ", "))
if (-not $NoAutoMeta) {
  if (-not [string]::IsNullOrWhiteSpace($series)) {
    Write-Output "Series: $series"
    Write-Output "Series Part: $seriesPart"
  }
  Write-Output "Series Buildable: $($seriesBuildable.ToString().ToLowerInvariant())"
  Write-Output "Hot: $($hot.ToString().ToLowerInvariant())"
}


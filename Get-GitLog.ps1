function Get-GitLog {
    $RawGitLog = Invoke-Command -ScriptBlock { git log --pretty=tformat:'\"%h\",\"%s\",\"%ci\",\"%an\"' --numstat --no-merges } | Where-Object { $PSItem }

    for ($Counter = 0; $Counter -lt $RawGitLog.Count; $Counter++) {
        if ($RawGitLog[$Counter] -match '[0-9a-f]{7}') {
            if ($OutputLog) {
                $OutputLog
            }
            $OutputLog = $RawGitLog[$Counter] | ConvertFrom-Csv -Header 'Hash', 'Message', 'Time', 'Author', 'AddedLines', 'RemovedLines'
            $OutputLog.AddedLines = 0
            $OutputLog.RemovedLines = 0
        }
        else {
            $FileLine = $RawGitLog[$Counter] -split '\s' | Where-Object { $PSItem -match '\d' }
            if ($FileLine) {
                $OutputLog.AddedLines += $FileLine[0]
                $OutputLog.RemovedLines += $FileLine[1]
            }
        }
    }
}
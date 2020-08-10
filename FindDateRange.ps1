Param ([switch]$Verbose, $NewestValidDate=[DateTime]::Now, $OldestValidDate='03/24/1970 00:00:00', $Path='.', [switch]$Help )

if ($Help) {
	"`nSYNTAX`n`tFindDateRange [-Verbose] [$NewestValidDate '12/31/2005 00:00:00'] [$OldestValidDate '03/24/1970 00:00:00'] [Path 'c:\Your\Directory'] [-Help]`n"
	exit
}

$olddate = [DateTime]::MaxValue
$newdate = [DateTime]::MinValue

$oldfn = ""
$newfn = ""

get-childitem -recurse $Path | ForEach-Object {
	if ($_.LastWriteTime -gt $OldestValidDate) {
		if ($_.LastWriteTime -lt $olddate -and -not $_.PSIsContainer) {
			$oldfn = $_.FullName
			$olddate = $_.LastWriteTime

			if ($Verbose) {
				"`tOldest: " + $olddate + " -- " + $_.Name
			}
		}
	}

	if ($_.LastWriteTime -lt $NewestValidDate) { 
		if ($_.LastWriteTime -gt $newdate -and -not $_.PSIsContainer) {

			$newfn = $_.FullName
			$newdate = $_.LastWriteTime

			if ($Verbose) {
				 "`tNewest: " + $newdate + " -- " + $_.Name
			}
		}
	}
}

$output = ""
if ($oldfn -ne "") { $output += "`nOldest: " + $olddate + " -- " + $oldfn }
if ($newfn -ne "") { $output += "`nNewest: " + $newdate + " -- " + $newfn }
if ($output -eq "") { $output += "`nFolder is empty." }
$output + "`n"
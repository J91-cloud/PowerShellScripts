# First, declare the paths and settings
$watcherPath = "C:\Users\jessy\Documents"
$watchFilter = "*.*"
$includeSubDirectories = $true

# Create the watcher object - simplified creation
# Set Each Property One at a time.
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watcherPath
$watcher.Filter = $watchFilter
$watcher.IncludeSubDirectories = $includeSubDirectories
$watcher.NotifyFilter = [IO.NotifyFilters]::FileName -bor [IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

# Define the action
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $status = switch ($changeType) {
        'Created' { 'Added' }
        'Deleted' { 'Removed' }
    }
    Write-Host ("FileName: " + ($path | Split-Path -Leaf) + 
                ", Directory Placed: " + ($path | Split-Path -Parent) + 
                ", Status: $status, Date and Time: $(Get-Date)")
}

# Register the events
Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $action
Register-ObjectEvent -InputObject $watcher -EventName 'Deleted' -Action $action

# Keep script running
while ($true) { Start-Sleep -Seconds 1 }
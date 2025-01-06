# First, declare the paths and settings
$watcherPath = "C:\Users\jessy\Documents"
$watchFilter = "*.*"
$includeSubDirectories = $true
$excelFilePath = "C:\Users\jessy\Documents\ExcelFile.xlsx"
$excelSheetName = "Sheet1"

# Create the watcher object
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watcherPath
$watcher.Filter = $watchFilter
$watcher.IncludeSubDirectories = $includeSubDirectories
$watcher.NotifyFilter = [IO.NotifyFilters]::FileName -bor [IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

# Define the action to add rows to Excel
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

    # Open Excel and add the new row
    $xl = New-Object -ComObject Excel.Application
    $xl.Visible = $false
    
    $workbook = $xl.Workbooks.Open($excelFilePath)
    $worksheet = $workbook.Worksheets.Item($excelSheetName)
    $lastRow = $worksheet.UsedRange.Rows.Count + 1
    
    # Add values to the new row
    $newRowValues = @(
        ($path | Split-Path -Leaf), # File Name
        ($path | Split-Path -Parent), # Directory
        $status, # Status
        $(Get-Date) # Date and Time
    )

    for ($i = 0; $i -lt $newRowValues.Count; $i++) {
        $worksheet.Cells.Item($lastRow, $i + 1).Value = $newRowValues[$i]
    }

    $workbook.Save()
    $workbook.Close()
    $xl.Quit()

    # Clean up
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl) | Out-Null
    Remove-Variable xl
}

# Register the events
Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $action
Register-ObjectEvent -InputObject $watcher -EventName 'Deleted' -Action $action

# Keep script running
while ($true) { Start-Sleep -Seconds 1 }

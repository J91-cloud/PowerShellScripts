
$ServerInstance = "LAPTOP-NKHMEJGP"
$DatabaseName = "CareerPortfolio"

$lastIDQuery = "SELECT MAX(ID) AS MaxID FROM [dbo].[JobApplications]"

try {
    $lastIDResult = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $lastIDQuery
    $lastID = $lastIDResult.MaxID
    if (-not $lastID) { $lastID = 0 }  # If no records exist, start from ID 0
    Write-Host "Starting with ID: $lastID"
} catch {
    Write-Host "An error occurred while fetching the last ID:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit
}

while ($true) {
    try {
        $query = @"
        SELECT *
        FROM [dbo].[JobApplications]
        WHERE ID > $lastID
"@


        $results = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $query

        if ($results) {
            # Display new records
            foreach ($row in $results) {
                Write-Host "New record detected:" -ForegroundColor Green

                # Display column names and values
                for ($i = 0; $i -lt $row.ItemArray.Length; $i++) {
                    $columnName = $row.Table.Columns[$i].ColumnName
                    $columnValue = $row.ItemArray[$i]
                    Write-Host "$columnName : $columnValue"
                }

                Write-Host "----------------------------------------"
            }

            # Update the last known ID to the maximum ID found in the current query
            $lastID = $results | Measure-Object -Property ID -Maximum | Select-Object -ExpandProperty Maximum
        } else {
            Write-Host "No new records detected." -ForegroundColor Yellow
        }

        # Delay before the next check
        Start-Sleep -Seconds 5
    } catch {
        Write-Host "An error occurred while executing the SQL query:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

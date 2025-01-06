$ServerInstance = "LAPTOP-NKHMEJGP"
$DatabaseName = "CareerPortfolio"
$Query = "SELECT * FROM dbo.JobApplications"


try {
    $Result = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $Query

    if ($Result) {
        Write-Host "Query executed successfully. Rsults: " -ForegroundColor Green

        $Result | ForEach-Object {
            Write-Host ($_ | Out-String)
        }
        
    }else {
        Write-Host "Query executed successfully, but no rows were returned." -ForegroundColor Yellow
    }
} catch {
    Write-Host "An error occurred while executing the SQL query:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

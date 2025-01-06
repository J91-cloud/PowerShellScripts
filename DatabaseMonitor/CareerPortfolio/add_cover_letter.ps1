param(
    [string]$Title,
    [string]$Content,
    [string]$FilePath
)

if (-not $Title) {
    $Title = Read-Host "Enter the Title of Resume"
}
if (-not $Content) {
    $Content = Read-Host "Enter the Content of the Resume"
}
if (-not $FilePath) {
    $FilePath = Read-Host "What Directory is your Resume in?"
}

$connectionString = "Server=LAPTOP-NKHMEJGP;Database=CareerPortfolio;Integrated Security=True;"
$query = @"
        INSERT INTO [dbo].[JobApplications]
        ([Title], [Content], [FilePath])
        VALUES
            ('$Title','$Content','$FilePath')
"@

Invoke-Sqlcmd -ConnectionString $connectionString -Query $query 
Write-Host "Your Resume has been added"


param(
    [string]$Company,
    [string]$Position,
    [int]$ResumeID,
    [int]$CoverLetterID,
    [string]$AppliedDate
)

# Asking the user for each parameter value if they are not provided
if (-not $Company) {
    $Company = Read-Host "Enter the Company"
}
if (-not $Position) {
    $Position = Read-Host "Enter the Position"
}
if (-not $ResumeID) {
    $ResumeID = Read-Host "Enter the Resume ID"
}
if (-not $CoverLetterID) {
    $CoverLetterID = Read-Host "Enter the Cover Letter ID"
}
if (-not $AppliedDate) {
    $AppliedDate = Read-Host "Enter the Applied Date"
}

$connectionString = "Server=LAPTOP-NKHMEJGP;Database=CareerPortfolio;Integrated Security=True;"

$query = @"
INSERT INTO [dbo].[JobApplications]
           ([Company], [Position], [ResumeID], [CoverLetterID], [AppliedDate])
     VALUES
           ('$Company', '$Position', $ResumeID, $CoverLetterID, '$AppliedDate')
"@

# Run the SQL query
Invoke-Sqlcmd -ConnectionString $connectionString -Query $query

Write-Host "New job application inserted: $Company, $Position, $AppliedDate"

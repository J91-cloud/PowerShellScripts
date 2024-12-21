## Possible Errors
>[!Warning]
When doing this on your own, be carefule about FileWatchers, if not handled properly you will end up with numnerous fileWatchers. If erorrs or events are showing when file is stopped. Perform the following actions.
- Perform the Command `Get-EventSubscriber` : List all Events
- Perform the Command `Get-EventSubscriber | Unregister-Event` or `Get-Job | Remove-Job -Force`: De-List all events
  To Prevent this Error from happening make sure inside your script you have a way to delete all events when stopping
```shell
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    # Clean up here
    Unregister-Event -SourceIdentifier $createdSubscription.SourceIdentifier
    Unregister-Event -SourceIdentifier $deletedSubscription.SourceIdentifier
    $watcher.Dispose()
    Write-Host "Monitoring stopped."
}
```


## Run the Script


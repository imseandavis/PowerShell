function Get-ErrorInfo
{
  param
  (
    [Parameter(ValueFrompipeline)]
    [Management.Automation.ErrorRecord]$errorRecord
  )
 
 
  process
  {
    $info = [PSCustomObject]@{
      Exception = $errorRecord.Exception.Message
      Reason    = $errorRecord.CategoryInfo.Reason
      Target    = $errorRecord.CategoryInfo.TargetName
      Script    = $errorRecord.InvocationInfo.ScriptName
      Line      = $errorRecord.InvocationInfo.ScriptLineNumber
      Column    = $errorRecord.InvocationInfo.OffsetInLine
      Date      = Get-Date
      User      = $env:username
    }
    
    $info
  }
}


#Example Usage - Stop On Error
Write-Host "Stop On Error Example"
try 
{
    Stop-Service -Name FakeService -ErrorAction Stop
}  
catch 
{
    $_ | Get-ErrorInfo
}

#Example Usage - Silently Continue
Write-Host "Silent Example"
$Result = Get-ChildItem -Path C:\Windows -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue -ErrorVariable MyErrors
$MyErrors | Get-ErrorInfo

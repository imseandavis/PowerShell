#The clean way to call balloon tips
function Show-BalloonTip
{
    param
    (
        [Parameter(Mandatory=$true)][string]$Text,
        [string]$Title = "Message from PowerShell",
        [ValidateSet('Info','Warning','Error','None')][string]$Icon = 'Info'
    )
 
    Add-Type -AssemblyName  System.Windows.Forms
 
    # we use private variables only. No need for global scope
    $balloon = New-Object System.Windows.Forms.NotifyIcon
    $cleanup =
    {    
        # this gets executed when the user clicks the balloon tip dialog
 
        # take the balloon from the event arguments, and dispose it
        $event.Sender.Dispose()
        # take the event handler names also from the event arguments,
        # and clean up 
        Unregister-Event  -SourceIdentifier $event.SourceIdentifier
        Remove-Job -Name $event.SourceIdentifier
        $name2 = "M" + $event.SourceIdentifier
        Unregister-Event  -SourceIdentifier $name2
        Remove-Job -Name $name2
    }
    $showBalloon =
    {
        # this gets executed when the user clicks the tray icon
        $event.Sender.ShowBalloonTip(5000) 
    }
 
    # use unique names for event handlers so you can open multiple balloon tips
    $name = [Guid]::NewGuid().Guid
 
    # subscribe to the balloon events
    $null = Register-ObjectEvent -InputObject $balloon -EventName BalloonTipClicked -Source $name -Action $cleanup
    $null = Register-ObjectEvent -InputObject $balloon -EventName MouseClick -Source "M$name" -Action $showBalloon
 
    # use the current application icon as tray icon
    $path = (Get-Process -id $pid).Path
    $balloon.Icon  = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
 
    # configure the balloon tip
    $balloon.BalloonTipIcon  = $Icon
    $balloon.BalloonTipText  = $Text
    $balloon.BalloonTipTitle  = $Title
 
    # make the tray icon visible
    $balloon.Visible  = $true
    # show the balloon tip
    $balloon.ShowBalloonTip(5000) 
}

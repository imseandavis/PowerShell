#Old School Way Of Service Bus Tesating In PowerShell
Import-Module "PATH_TO_Microsoft.ServiceBus.dll"

#Create the required credentials
$tokenProvider = [Microsoft.ServiceBus.TokenProvider]::CreateSharedSecretTokenProvider("owner", "YOUR_ISSUERSECRET")
$namespaceUri = [Microsoft.ServiceBus.ServiceBusEnvironment]::CreateServiceUri("sb", "YOUR_NAMESPACE", "");
$namespaceManager = New-Object Microsoft.ServiceBus.NamespaceManager $namespaceUri,$tokenProvider

#Create a queue
$queue = $namespaceManager.CreateQueue("MyPowershellQueue");

#Create a message factory
$factory = [Microsoft.ServiceBus.Messaging.MessagingFactory]::Create($namespaceUri, $tokenProvider)

#Create a sender (with ReceiveAndDelete mode) and send a few messages
$sender = $factory.CreateMessageSender($queue.Path)

#Send a few messages
1..10 | ForEach-Object { $sender.Send("Message from Powershell " + [Guid]::NewGuid()) }

#Create a message receiver (with ReceiveAndDelete mode) and receive the messages
$receiver = $factory.CreateMessageReceiver($queue.Path, [Microsoft.ServiceBus.Messaging.ReceiveMode]::ReceiveAndDelete)

#Receive the messages
1..10 | ForEach-Object { Write-Output "Received " + $receiver.Receive([TimeSpan]::FromSeconds(10))}

#Close the factory
$factory.Close()

# SENDS SAMPLE TWITTER MESSAGE CARD TO TEAMS

$body = @"
{
    "@context": "https://schema.org/extensions",
    "@type": "MessageCard",
    "potentialAction": [
        {
            "@type": "OpenUri",
            "name": "View All Tweets",
            "targets": [
                {
                    "os": "default",
                    "uri": "https://twitter.com/search?q=%23MicrosoftTeams"
                }
            ]
        }
    ],
    "sections": [
        {
            "facts": [
                {
                    "name": "Posted By:",
                    "value": ""
                },
                {
                    "name": "Posted At:",
                    "value": ""
                },
                {
                    "name": "Tweet:",
                    "value": ""
                }
            ],
            "text": "A tweet with #MicrosoftTeams has been posted:"
        }
    ],
    "summary": "Tweet Posted",
    "themeColor": "0072C6",
    "title": "Tweet Posted"
}
"@

$uri = 'YOUR INCOMING WEBHOOK URL GOES HERE'

Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'

#Set octo required inputs

$apiKey = $OctopusParameters['ApiKey']
$user = $OctopusParameters['User']
$appId = $OctopusParameters['AppId']
$revision = $OctopusParameters['Octopus.Release.Number']
$releaseNotes = $OctopusParameters['confuenceNotes']

#Set Standard Vars
$uri = "https://api.newrelic.com/v2/applications/$appId/deployments.json"
$body = @{
    "deployment"= @{
    "revision"= "$revision"
    "changelog"= "Added: /v2/deployments.rb, Removed: None"
    "description"= "Added a deployments resource to the v2 API"
    "Release Notes"="$releaseNotes"
    "user"= "$user"
}
}
$jbody = $body | ConvertTo-Json


Invoke-WebRequest -Uri $uri -Method POST -Headers @{'X-Api-Key'="$APIKEY"} -ContentType 'application/json' -Body $jbody

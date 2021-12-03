# Upload user activity to DB

Azure function to deploy information about user's actions to Azure SQL

## Installation 
 
Install Azure Function Tools verison 3
https://docs.microsoft.com/ru-ru/azure/azure-functions/functions-run-local?tabs=linux#v2

Install all packages from requirements.txt for your python3

## Run

### Start the func local

Add storage and event hub creds to local.settings.json

Start func

`func start`

### Deploy the func to Azure

`func azure functionapp publish <name_func>`

## Test

For local test
`http://localhost:7071/api/HttpTrigger?health=true`

For azure test
`https://<URL_FUNC>.azurewebsites.net/api/HttpTrigger?code=<SECRET_CODE>&health=true`
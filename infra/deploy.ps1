az account set --subscription "90f5fdbd-fc04-461d-9c7b-df603d2efd6d"

az containerapp env show --name "ContainerAppEnvironment02" --resource-group "platform-management" --query id --output tsv
param virtualNetworkName string = 'democontainerappmultipleports'
param subnetName string = 'ContainerAppSubnet'
param addressPrefix string = '10.0.0.0/16'
param subnetAddressPrefix string = '10.0.2.0/24'
param location string = 'westeurope'
param name_quickstart string = 'quickstart'
param name_vector string = 'vector'
param environmentName string = 'democontainerappmultipleports'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
    delegations: [
      {
        name: 'containerappdelegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
   
  }
}

resource environment 'Microsoft.App/managedEnvironments@2023-05-02-preview' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'azure-monitor'
      logAnalyticsConfiguration: null
    }
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    vnetConfiguration: {
      infrastructureSubnetId: subnet.id
      internal: false
    }
    zoneRedundant: false
    infrastructureResourceGroup: 'democontainerappmultipleports-managed'
  }
  dependsOn: [
    virtualNetwork
  ]
}

var environmentRef = resourceId('Microsoft.App/managedEnvironments', environmentName)

resource quickstart_containerapp 'Microsoft.App/containerApps@2023-08-01-preview' = {
  name: name_quickstart
  kind: 'containerapps'
  location: location
  properties: {
    environmentId: environmentRef
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        targetPort: 80
        additionalPortMappings: [
          {
            external: true
            targetPort: 81
            exposedPort: 81
          }
        ]        
      }

    }
    template: {
      containers: [
        {
          name: 'simple-hello-world-container'
          image: 'mcr.microsoft.com/k8se/quickstart:latest'
          command: []
          resources: {
            cpu: '0.25'
            memory: '.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
    workloadProfileName: 'Consumption'
  }
//  dependsOn: [
//    environment
//  ]
}

resource quickstart_vector 'Microsoft.App/containerApps@2023-08-01-preview' = {
  name: name_vector
  kind: 'containerapps'
  location: location
  properties: {
    environmentId: environmentRef
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        targetPort: 6333
        additionalPortMappings: [
          {
            external: true
            targetPort: 6334
            exposedPort: 6334
          }
        ]        
      }
    }
    template: {
      containers: [
        {
          name: 'qdrant'
          image: 'qdrant/qdrant:v1.6.1'
          command: []
          resources: {
            cpu: '0.25'
            memory: '.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
    workloadProfileName: 'Consumption'
  }
//  dependsOn: [
//    environment
//  ]
}

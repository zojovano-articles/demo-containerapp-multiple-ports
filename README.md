# Demo - Container App with multiple ports

This demo is using Container Apps feature to enable multiple TCP ports from single container. 
The Bicep code creates 
- VNET with dedicated subnet for Container Apps Environment
- Container App Environment with custom VNET
- Container App with qdrant vector DB exposing HTTP and gRPC endpoints

## References

- https://learn.microsoft.com/en-us/azure/container-apps/ingress-how-to
- https://learn.microsoft.com/en-us/azure/container-apps/vnet-custom

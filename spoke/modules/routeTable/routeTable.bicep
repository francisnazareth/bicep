param location string
param routeTableName string
param tagValues object
param firewallPrivateIP string

resource symbolicname 'Microsoft.Network/routeTables@2023-04-01' = {
  name: routeTableName
  location: location
  tags: tagValues
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        id: 'route-all-traffic-to-fw'
        name: 'route-all-traffic-to-fw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: firewallPrivateIP
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
}

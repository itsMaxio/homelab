# Enabling Communication Between LAN and IOT VLANs for Chromecast on OPNsense

> OPNsense version: 25.7.3_7

## 1: Choose and Install a Multicast Relay Plugin

You can use one of two optionss:

### A: Install the `MDNS Repeater Plugin`

1. Log in to your OPNsense dashboard
2. Navigate to **System > Firmware > Plugins**
3. Search for the `os-mdns-repeater` plugin in the list
4. Click **Install** to add the MDNS Repeater plugin

### B: Install the `UDP Broadcast Relay Plugin`

1. Log in to your OPNsense dashboard
2. Navigate to **System > Firmware > Plugins**
3. Search for the `os-udpbroadcastrelay` plugin in the list
4. Click **Install** to add the UDP Broadcast Relay plugin

## 2: Configure the Plugin

### A: Configure MDNS Repeater

1. Navigate to **Services > MDNS Repeater** in the OPNsense dashboard
2. Under **Listen Interfaces**, select both your `IOT VLAN` and `LAN VLAN`
3. Click **Save** to apply the configuration

### B: Configure UDP Broadcast Relay

1. Navigate to **Services > UDP Broadcast Relay** in the OPNsense dashboard.
2. Create a new relay instance with the following settings:
   - **Enabled**: `true`
   - **Relay Port**: `5353`
   - **Relay Interfaces**: `VLAN LAN` and `VLAN IOT`
   - **Broadcast Address**: `224.0.0.251`
   - **Source Address**: `1.1.1.1`
   - **Instance ID**: Any value of your choice
   - **Use TTL for ID**: `false`
   - **Description**: Any value of your choice
3. Click **Save** to apply the configuration

## 3: Create an Alias for Required Ports

1. Go to **Firewall > Aliases**
2. Click **+ Add** to create a new alias
3. Set the following:
   - **Name**: `Chromecast_Ports`
   - **Type**: `Port(s)`
   - **Ports**: `1900`, `5353`, `8008`, `8009`, `8443`, `8080`
4. Save the alias and apply the changes

## 4: Create Firewall Rules on VLAN Interfaces

### Rule on LAN Interface

1. Navigate to **Firewall > Rules > [LAN]**
2. Click **+ Add** to create a new rule
3. Configure the rule as follows:
   - **Action**: `Pass`
   - **Protocol**: `TCP/UDP`
   - **Source**: `LAN net`
   - **Destination**: `IoT VLAN net`
   - **Destination Port Range**: Select the alias `Chromecast_Ports` created earlier
   - **Description**: Any value of your choice, eg `Allow LAN to IoT for Chromecast`
4. Click **Save** and **Apply Changes**

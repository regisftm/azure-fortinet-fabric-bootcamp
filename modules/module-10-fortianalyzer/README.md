# Module 10 - FortiAnalyzer Deployment

## Centralized Logging and Analytics

### Overview

FortiAnalyzer provides centralized logging, reporting, and analytics for all FortiGate devices in your security fabric. In this module, we'll deploy FortiAnalyzer in the Azure hub network and configure it to collect logs from both the Azure FortiGate cluster and the on-premises FortiGate.

### Learning Objectives

By the end of this module, you will have:

- Deployed FortiAnalyzer VM in the Azure hub network
- Configured log forwarding from Azure FortiGate cluster
- Set up log collection from on-premises FortiGate
- Explored FortiAnalyzer's reporting and analytics capabilities
- Established centralized security monitoring

---

## Understanding FortiAnalyzer Architecture

### Deployment Overview

```mermaid
graph TB
    subgraph "Azure Hub (10.16.0.0/16)"
        subgraph "protected subnet (10.16.6.0/24)"
            FAZ[FortiAnalyzer<br/>10.16.6.10]
            HUBVM[vm-hub-jumpbox<br/>10.16.6.4]
        end
        
        subgraph "internal subnet (10.16.3.0/24)"
            FGTA[FortiGate A]
            FGTB[FortiGate B]
        end
    end
    
    subgraph "On-Premises (172.16.0.0/16)"
        ONPREMFGT[on-prem-FGT]
    end
    
    subgraph "Spoke Networks"
        SPOKE1[Spoke1 VMs]
        SPOKE2[Spoke2 VMs]
    end
    
    %% Log flows
    FGTA -->|Logs| FAZ
    FGTB -->|Logs| FAZ
    ONPREMFGT -.->|Logs via VPN| FAZ
    
    %% Traffic flows being logged
    SPOKE1 --> FGTA
    SPOKE2 --> FGTB
    
    style FAZ fill:#4CAF50
    style FGTA fill:#ff6b6b
    style FGTB fill:#ff6b6b
    style ONPREMFGT fill:#ff6b6b
```

---

## Step 1: Deploy FortiAnalyzer VM

### 1.1 Start FortiAnalyzer Deployment

1. Navigate to **`rg-hub-bootcamp`** resource group
2. Click **"+ Create"**
3. Search for: **`FortiAnalyzer`**
4. Select **"FortiAnalyzer Centralized Log Analytics by Fortinet"**
5. Click **"Create"**
6. Select **Fortinet Analyzer - Single VM**

![create-fortianalyzer.screenshot](images/1.1-create-faz.gif)

### 1.2 Configure Basic Settings

1. **Basics** configuration:
   - **Subscription**: Your subscription
   - **Resource group**: `rg-hub-bootcamp`
   - **Region**: `Canada Central`
   - **FortiAnalyzer administrative username**: `fortinetuser`
   - **FortiAnalyzer password**: Create a strong password
   - **FortiAnalyzer Name Prefix**: `hub`
   - **FortiAnalyzer Image SKU**: `Bring Your Own License`
   - **FortiAnalyzer Image Version**: `7.6.3`
2. Click **"Next"**

![basics-configuration.screenshot](images/1.2-basics-config.png)

### 1.3 Configure Instance Settings

1. **Instance** configuration:
   - **Instance Type**: `Standard_D4s_v5` (4 vCPUs, 16 GB RAM)
   - **Storage**: `512GiB`
   - **Type of managed disks**: `Default disks for instance type`
  
   ![instance-configuration-a.screenshot](images/1.3-instance-config-a.png)

   - **Availability Option**: `No infrastructure redundancy required`
   - **My organisation is using the FortiFlex subscription service.**: `Checked`
   - **FortiAnalyzer FortiFlex**: Token provided by your instructor
   - **Name of the FortiAnalyzer VM**: `hub-faz`

   ![instance-configuration-b.screenshot](images/1.3-instance-config-b.png)

2. Click **"Next"**

### 1.4 Configure Networking

1. **Networking** configuration:
   - **Virtual network**: `vnet-hub`
   - **Subnet**: `protected (10.16.6.0/24)`

   ![networking-configuration.screenshot](images/1.4-network-config.png)

2. Click **"Next"**
   - **Public IP**: `None` (access via Bastion)

   ![public-ip-configuration.screenshot](images/1.4.2-pip-config.png)

### 1.5 Deploy

1. Click **"Review + create"** then **"Create"**
2. Wait for deployment to complete (~5-10 minutes)

### 1.6 Configuring a static IP for FortiAnalyzer VM

Using a static IP makes configuration easier and ensures consistent connectivity even after VM restarts.

1. Navigate to **`rg-hub-bootcamp`** resource group
2. Select **`hub-faz-nic1`**
3. Under **Settings**, click **"IP configurations"**
4. Click **"ipconfig1"**
5. Edit "**IP configurations**"
   - **Private IP address**: `10.16.6.10`
   - Click **"Save"**

![configuring-static-ip-faz.screenshot](images/1.6-static-ip-faz.png)

---

## Step 2: Initial FortiAnalyzer Configuration

### 2.1 Load the license

1. Connect to **`vm-hub-jumpbox`** via Bastion
2. Open **Command Prompt**
3. Open a SSH session with FortiAnalyzer

   ```bash
   ssh fortinetuser@10.16.6.10
   ```

4. Run the command below to load the FortiFlex license using the token gave to you by the instructor

   ```bash
   execute vm-license < FortiFlex token>
   ```

5. **FortiAnalyzer** will reboot to apply the license
6. Open **Command Prompt**

![exec-vm-license.screenshot](images/2.1-vm-license.png)

### 2.2 Access FortiAnalyzer

1. Open the web browser from **`vm-hub-jumpbox`**
2. Navigate to: `https://10.16.6.10`
3. Accept security certificate warnings
4. Complete FortiAnalyzer basic setup

### 2.3 Basic System Configuration

1. **System Settings > Settings**:
   - **Idle timeout (GUI)**: `3600` Seconds (1 hour)

---

## Step 3: Configure Azure FortiGate Log Forwarding

### 3.1 Access Azure FortiGate A

1. Open a new browser tab
2. Navigate to the **FortiGate A** management IP
3. Login with **FortiGate** credentials

### 3.2 Configure FortiAnalyzer Connector

1. Navigate to **Security Fabric** → **Fabric Connectors**
2. Click on **FortiAnalyzer**
3. Click **"Edit"**

   ![fabric-connector.screenshot](images/3.2a-fabric-connector.png)

4. Configure the connector:
   - **Status**: `Enable`
   - **Server**: `10.16.6.10`
   - **Upload Option**: `Real Time`
5. Click **"OK"** to apply changes
6. Accept the FortiAnalyzer certificate when prompted
7. Wait for connection establishment

![alt text](images/3.2b-logging-analytics-config.png)

### 3.3 Authorize Device in FortiAnalyzer

1. From the jumpbox, open Microsoft Edge
2. Navigate to: `https://10.16.6.10`
3. Navigate to **Device Manager**
4. Click **"Unauthorized Devices"**
5. Select the Azure FortiGate device
6. Click **"Authorize"**

   ![authorize-faz.screenshot](images/3.3-authoriza-faz.png)

7. Click **"Authorize"** in the **"Authorize Device"** window

   ![authorized-device.screenshot](images/3.3-authorized-device.png)

### 3.4 Verify Connection Status

1. Wait a few minutes for connection establishment
2. Refresh the FortiAnalyzer page
3. Verify connection status shows as connected
4. Return to the FortiGate and check **Security Fabric** → **Fabric Connectors** for connection status

![fabric-connector-status.screenshot](images/3.4-fabric-connected.png)

### 3.5 Configure On-Premises FortiGate

1. Access the on-premises FortiGate web interface
2. Repeat the same configuration process (steps 3.2-3.4)
3. Use the same FortiAnalyzer IP: `10.16.6.10`

![all-devices-connected.screenshot](images/3.5-all-connected.png)

---

## Step 4: Configure Azure FortiGate Log settings

### 4.1 Configure Event Logging

1. In **Log & Report**, click **"Log Settings"**
2. Enable logging for:
   - **UUIDs in Traffic Log**:
     - **Address**: `Enabled`
   - **Log Settings**:
     - **Event logging**: `All`
     - **Local traffic logging**: `All`
     - **Syslog logging**: `Disable`
   - **GUI Preferences**:
     - **Resolve hostnames**: `Enabled`
     - **Resolve unknown applications**: `Enabled`

   ![log-settings.screenshot](images/4.1-event-logging-config.png)

3. Click **"Apply"**

### 4.2 Configure Traffic Logging

1. Navigate to **Policy & Objects** → **Firewall Policy**
2. Edit each existing policy (internet_access, spoke policies, etc.)
3. In **Security Profiles** section:
   - **Log Allowed Traffic**: `All Sessions`
   - **Log Denied Traffic**: `Enable`
4. Click **"OK"** for each policy

### 4.3 Repeat for FortiGate on-prem

1. Access FortiGate on-prem using its management IP
2. Configure identical log settings as FortiGate A
3. Ensure both FortiGates send logs to the same FortiAnalyzer

---

## Step 5 Generate and View Log Data

### 5.1 Generate Traffic for Logging

1. From various VMs, generate different types of traffic:

   ```bash
   # Internet access (generates traffic logs)
   curl https://www.fortinet.com
   curl https://www.yahoo.com
   
   # Inter-spoke traffic
   ssh azureuser@192.168.2.4
   
   # Cross-site traffic through VPN
   ssh azureuser@172.16.4.4
   ```

---

## Step 6: Explore FortiAnalyzer Features

### 6.1 Dashboard Overview

1. Navigate to **Dashboard** → **Status**
2. Explore widgets

![dashboard-status.screenshot](images/6.1-dashboard.png)

### 6.2 FortiView Overview

1. Navigate to **FortiView** → **Local System Performance**
2. Explore widgets:

![fortiview-performance.screenshot](images/6.2-fortiview.png)

### 6.3 View Traffic Logs

1. In FortiAnalyzer, navigate to **Log View** → **Logs**
2. Observe real-time logs from all FortiGates
3. Filter by:
   - **Source Device**: Select specific FortiGate
   - **Source IP**: Filter by subnet
   - **Destination**: Filter by destination networks

![view-traffic-logs.screenshot](images/6.3-view-traffic-logs.png)

### 6.4 View Event Logs

1. Navigate to **Incidents & Events** → **Event Monitor**
2. Explore the tabs:
   - All events
   - By Endpoint
   - By Threat
   - System Events

![view-event-logs.screenshot](images/6.4-event-logs.png)

---

## Verification Checklist

Before proceeding to Module 11, verify you have completed:

**FortiAnalyzer Deployment:**

- [ ] Deployed FortiAnalyzer VM with static IP 10.16.6.10
- [ ] Completed initial setup and admin password configuration
- [ ] Configured timezone and system settings

**Log Configuration:**

- [ ] Configured Azure FortiGate A and B Security Fabric to send logs to FortiAnalyzer
- [ ] Configured on-premises FortiGate to send logs via VPN to FortiAnalyzer
- [ ] Enabled traffic logging on all firewall policies

**Device Registration:**

- [ ] Added all three FortiGates to FortiAnalyzer device list
- [ ] Verified connectivity status shows as connected
- [ ] Generated test traffic and confirmed logs are being received

**Analytics Verification:**

- [ ] Viewed traffic logs from all devices
- [ ] Reviewed event logs for system activities
- [ ] Explored dashboard and reporting features

---

## Architecture Review

After completing this module, your logging architecture should look like this:


      
---

## Troubleshooting Common Issues

### Issue: FortiAnalyzer not receiving logs

**Solution:**

- Verify if FortiGate Fabric Connectors for FortiAnalyzer is `Connected`
- Check that traffic logging is enabled on firewall policies

### Issue: On-premises logs not appearing

**Solution:**

- Verify VPN tunnel is established and stable
- Check that on-premises FortiGate can reach 10.16.6.10 through tunnel
- Confirm remote logging configuration on on-premises device

### Issue: Device registration fails

**Solution:**

- Verify IP addresses are correct and reachable
- Check admin credentials are correct
- Ensure devices are not behind additional firewalls blocking management traffic

---

## Next Steps

Once you've completed this module and verified centralized logging, you're ready to proceed to **Module 11: FortiManager Deployment**.

Module 11 will complete the Security Fabric with centralized management and policy distribution.

**Estimated completion time**: 35-40 minutes

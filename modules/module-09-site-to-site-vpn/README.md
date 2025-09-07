# Module 9 - Site-to-Site IPSec VPN

## Connecting On-Premises and Azure Environments

### Overview
In this module, we'll establish a secure site-to-site IPSec VPN tunnel between the on-premises FortiGate and the Azure FortiGate cluster. This creates a hybrid connectivity solution that allows secure communication between on-premises and cloud resources.

### Learning Objectives
By the end of this module, you will have:
- Configured IPSec VPN on both FortiGate environments
- Established secure communication between on-premises and Azure networks
- Created firewall policies for cross-site connectivity
- Tested traffic flow through the VPN tunnel
- Validated hybrid network connectivity

---

## Understanding the VPN Architecture

### Network Overview
```mermaid
graph LR
    subgraph "On-Premises Environment"
        ONPREM[On-Prem FortiGate<br/>172.16.0.0/16]
        ONPREMWIN[vm-on-prem-windows<br/>172.16.4.4]
    end
    
    subgraph "Azure Environment"
        AZFGT[Azure FortiGate HA<br/>10.16.0.0/16]
        SPOKE1[Spoke1<br/>192.168.1.0/24]
        SPOKE2[Spoke2<br/>192.168.2.0/24]
    end
    
    subgraph "Internet"
        WEB((Internet))
    end
    
    ONPREM <-.->|IPSec VPN| WEB
    WEB <-.->|IPSec VPN| AZFGT
    ONPREM --- ONPREMWIN
    AZFGT --- SPOKE1
    AZFGT --- SPOKE2
    
    style ONPREM fill:#ff6b6b
    style AZFGT fill:#ff6b6b
```

### VPN Parameters
| Parameter | On-Premises | Azure Hub |
|-----------|-------------|-----------|
| **Local Subnets** | 172.16.4.0/24 | 192.168.1.0/24, 192.168.2.0/24 |
| **Public IP** | pip-on-prem-fgt | pip-hub-fgt |
| **Interface** | port1 (external) | port1 (external) |
| **Internal Interface** | port2 (internal) | port2 (internal) |

---

## Part A: Configure On-Premises FortiGate VPN

### Step 1: Access On-Premises FortiGate

#### 1.1 Get Public IP Address
1. Navigate to **`rg-on-prem-bootcamp`**
2. Click on **`pip-on-prem-fgt`**
3. Copy the **IP address**

#### 1.2 Log into FortiGate
1. Open browser: `https://[on-prem-public-ip]`
2. Login credentials:
   - **Username**: `fortinetuser`
   - **Password**: `Chicken12345!`

---

### Step 2: Get Azure FortiGate Public IP

#### 2.1 Find Azure FortiGate Public IP
1. Navigate to **`rg-hub-bootcamp`**
2. Click on **`pip-hub-fgt`** (External Load Balancer Public IP)
3. Copy the **IP address** (this will be the remote gateway)

> [!NOTE]
> We use the External Load Balancer IP because it's the public-facing IP for the Azure FortiGate cluster.

---

### Step 3: Create VPN on On-Premises FortiGate

#### 3.1 Start VPN Wizard
1. In on-premises FortiGate, navigate to **VPN** → **VPN Wizard**
2. Configure VPN Setup:
   - **Tunnel name**: `to_azure_hub`
   - **Template**: `Site to Site`
3. Click **"Begin"**

#### 3.2 Configure Remote Site
1. **Remote Site** configuration:
   - **Remote site device type**: `FortiGate`
   - **Remote site device**: `Accessible and static`
   - **IP address**: `[Azure-FortiGate-Public-IP]` (from Step 2.1)
   - **Remote site subnets**: `192.168.1.0/24`
2. Click **"Next"**

> [!NOTE]
> We'll start with Spoke1 subnet (192.168.1.0/24). We can add Spoke2 later or create additional tunnels.

#### 3.3 Configure VPN Tunnel
1. **VPN Tunnel** settings:
   - **Authentication Method**: `Pre-shared Key`
   - **Pre-shared Key**: `FortinetBootcamp2024!`
   - **IKE**: `Version 2`
   - **Transport**: `Auto`
   - **Use Fortinet encapsulation**: `Disabled`
   - **NAT traversal**: `Enable`
   - **Keepalive frequency**: `10`
2. Click **"Next"**

#### 3.4 Configure Local Site
1. **Local Site** configuration:
   - **Outgoing interface**: `port1` (external interface)
   - **Create and add interface to zone**: `Disabled`
   - **Local Interface**: `port2` (internal interface)
   - **Local subnets**: `172.16.4.0/24` (should auto-populate)
   - **Allow remote site's internet traffic**: `Disabled`
2. Click **"Next"**

#### 3.5 Review and Submit
1. Review all configurations
2. Click **"Submit"**

---

## Part B: Configure Azure FortiGate VPN

### Step 4: Access Azure FortiGate

#### 4.1 Connect to Active FortiGate
1. Navigate to **`rg-hub-bootcamp`**
2. Click on **`pip-hub-fgt-a-mgmt`**
3. Copy the **IP address**
4. Open browser: `https://[azure-fortigate-mgmt-ip]`
5. Login with same credentials

---

### Step 5: Create VPN on Azure FortiGate

#### 5.1 Start VPN Wizard
1. Navigate to **VPN** → **VPN Wizard**
2. Configure VPN Setup:
   - **Tunnel name**: `to_on_prem`
   - **Template**: `Site to Site`
3. Click **"Begin"**

#### 5.2 Configure Remote Site
1. **Remote Site** configuration:
   - **Remote site device type**: `FortiGate`
   - **Remote site device**: `Accessible and static`
   - **IP address**: `[On-Prem-FortiGate-Public-IP]` (from Step 1.1)
   - **Remote site subnets**: `172.16.4.0/24`
2. Click **"Next"**

#### 5.3 Configure VPN Tunnel
1. **VPN Tunnel** settings:
   - **Authentication Method**: `Pre-shared Key`
   - **Pre-shared Key**: `FortinetBootcamp2024!` (must match on-premises)
   - **IKE**: `Version 2`
   - **Transport**: `Auto`
   - **Use Fortinet encapsulation**: `Disabled`
   - **NAT traversal**: `Enable`
   - **Keepalive frequency**: `10`
2. Click **"Next"**

#### 5.4 Configure Local Site
1. **Local Site** configuration:
   - **Outgoing interface**: `port1` (external interface)
   - **Create and add interface to zone**: `Disabled`
   - **Local Interface**: `port2` (internal interface)
   - **Local subnets**: `192.168.1.0/24`
   - **Allow remote site's internet traffic**: `Disabled`
2. Click **"Next"**

#### 5.5 Review and Submit
1. Review all configurations
2. Click **"Submit"**

---

## Part C: Verify VPN Connectivity

### Step 6: Check VPN Status

#### 6.1 Verify On-Premises Tunnel
1. In on-premises FortiGate, navigate to **Dashboard** → **Network**
2. Open the **IPsec** widget
3. Look for tunnel `to_azure_hub` - status should show **"Up"**

**CLI Verification:**
```bash
diagnose vpn ike gateway list name to_azure_hub
```

#### 6.2 Verify Azure Tunnel
1. In Azure FortiGate, navigate to **Dashboard** → **Network**
2. Open the **IPsec** widget
3. Look for tunnel `to_on_prem` - status should show **"Up"**

**CLI Verification:**
```bash
diagnose vpn ike gateway list name to_on_prem
```

> [!TIP]
> If tunnels show "Down", wait 2-3 minutes for negotiation to complete. Check that public IPs and pre-shared keys match exactly.

---

### Step 7: Test Cross-Site Connectivity

#### 7.1 Test On-Premises to Azure
1. Connect to **`vm-on-prem-windows`** via Bastion
2. Open Command Prompt
3. Test connectivity:
   ```cmd
   ping 192.168.1.4
   ping 192.168.1.5
   ```

**Expected Result**: Should work if VPN tunnel is established

#### 7.2 Test Azure to On-Premises
1. Connect to **`vm-hub-jumpbox`** via Bastion
2. From PowerShell, test to on-premises:
   ```powershell
   ping 172.16.4.4
   ```

**Expected Result**: Should work through VPN tunnel

---

### Step 8: Add Spoke2 to VPN (Optional)

#### 8.1 Add Spoke2 Route on Azure Side
1. In Azure FortiGate, navigate to **Policy & Objects** → **Addresses**
2. Edit the automatically created address object for local subnets
3. Add `192.168.2.0/24` to include Spoke2

#### 8.2 Update VPN Phase2 Configuration
1. Navigate to **VPN** → **IPsec Tunnels**
2. Edit the `to_on_prem` tunnel
3. Update local and remote networks to include both spokes

---

## Verification Checklist

Before proceeding to the next module, verify you have completed:

**VPN Configuration:**
- [ ] Created VPN tunnel on on-premises FortiGate (`to_azure_hub`)
- [ ] Created VPN tunnel on Azure FortiGate (`to_on_prem`)
- [ ] Both tunnels show "Up" status in IPsec widget
- [ ] Pre-shared keys match on both sides

**Connectivity Testing:**
- [ ] Successfully pinged Azure Spoke1 VMs from on-premises
- [ ] Successfully pinged on-premises VM from Azure hub
- [ ] VPN tunnel traffic visible in FortiGate logs

**Network Integration:**
- [ ] VPN policies created automatically by wizard
- [ ] Static routes configured for remote subnets
- [ ] Address objects created for local and remote networks

---

## Architecture Review

After completing this module, your hybrid network should look like this:

```mermaid
graph TB
    subgraph "On-Premises (172.16.0.0/16)"
        subgraph "rg-on-prem-bootcamp"
            ONPREMFGT[on-prem-FGT]
            ONPREMWIN[vm-on-prem-windows<br/>172.16.4.4]
            PIPONPREM[pip-on-prem-fgt]
        end
    end
    
    subgraph "Internet"
        WEB((Internet))
        VPN[IPSec VPN Tunnel<br/>IKEv2 + PSK]
    end
    
    subgraph "Azure Hub (10.16.0.0/16)"
        subgraph "rg-hub-bootcamp"
            AZFGTA[FortiGate A]
            AZFGTB[FortiGate B]
            HUBVM[vm-hub-jumpbox<br/>10.16.6.4]
            PIPAZ[pip-hub-fgt]
        end
    end
    
    subgraph "Azure Spoke1 (192.168.1.0/24)"
        VM1A[vm-spoke1a<br/>192.168.1.4]
        VM1B[vm-spoke1b<br/>192.168.1.5]
    end
    
    subgraph "Azure Spoke2 (192.168.2.0/24)"
        VM2A[vm-spoke2a<br/>192.168.2.4]
    end
    
    %% VPN connections
    PIPONPREM --> VPN
    VPN --> PIPAZ
    VPN -.->|Encrypted| ONPREMFGT
    VPN -.->|Encrypted| AZFGTA
    VPN -.->|Encrypted| AZFGTB
    
    %% Local connections
    ONPREMFGT --- ONPREMWIN
    AZFGTA --- HUBVM
    AZFGTB --- HUBVM
    HUBVM <--> VM1A
    HUBVM <--> VM1B
    HUBVM <--> VM2A
    
    %% Cross-site connectivity through VPN
    ONPREMWIN <-.->|Through VPN| VM1A
    ONPREMWIN <-.->|Through VPN| VM1B
    
    style ONPREMFGT fill:#ff6b6b
    style AZFGTA fill:#ff6b6b
    style AZFGTB fill:#ff6b6b
    style VPN fill:#4CAF50
```

**Legend:**
- **Solid lines**: Direct network connections
- **Dotted lines**: VPN-encrypted traffic
- **Green tunnel**: Secure IPSec VPN connection

---

## Troubleshooting Common Issues

### Issue: VPN tunnel won't establish
**Solution:**
- Verify public IP addresses are correct on both sides
- Check pre-shared key matches exactly (case-sensitive)
- Ensure NAT traversal is enabled
- Verify FortiGates can reach each other's public IPs

### Issue: Tunnel is up but traffic doesn't flow
**Solution:**
- Check firewall policies allow VPN traffic
- Verify static routes are configured correctly
- Ensure local and remote subnet configurations match

### Issue: Only one direction works
**Solution:**
- Check that both sides have matching Phase1 and Phase2 settings
- Verify firewall policies exist for both directions

---

## Next Steps

Once you've completed this module and verified VPN connectivity, you're ready to proceed to **Module 10: FortiAnalyzer and FortiManager Deployment**.

In Module 10, we'll deploy centralized logging and management components to complete the Fortinet Security Fabric.

**Estimated completion time**: 30-35 minutes
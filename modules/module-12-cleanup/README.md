# Module 12 - Environment Cleanup

## Removing All Bootcamp Resources

### Overview
This final module guides you through the complete removal of all resources created during the bootcamp. Proper cleanup is essential to avoid ongoing charges in your Azure subscription.

### Important Notes
- **Cost Impact**: Leaving resources running will continue to incur charges
- **Order Matters**: Some resources must be deleted in specific order due to dependencies
- **Verification**: We'll verify complete removal to ensure no hidden costs

---

## Cost Estimate Review

Before cleanup, let's review what we deployed:

| Resource Type | Quantity | Estimated Daily Cost |
|---------------|----------|---------------------|
| FortiGate VMs (Azure HA) | 2 | $30-40 |
| FortiGate VM (On-premises) | 1 | $15-20 |
| FortiAnalyzer VM | 1 | $12-15 |
| FortiManager VM | 1 | $12-15 |
| Standard VMs | 6 | $15-25 |
| Load Balancers | 2 | $5-8 |
| Public IPs | 6+ | $3-5 |
| **Total Estimated Daily** | | **$92-128** |

> [!WARNING]
> **Monthly Cost**: If left running, these resources could cost $2,800-3,900 per month!

---

## Cleanup Methods

### Method 1: Resource Group Deletion (Recommended)
**Fastest and most complete method**

### Method 2: Individual Resource Deletion
**Use only if you need to preserve some resources**

---

## Method 1: Resource Group Deletion

### Step 1: Delete On-Premises Resource Group

#### 1.1 Navigate to Resource Groups
1. In Azure Portal, go to **"Resource groups"**
2. Find **`rg-on-prem-bootcamp`**
3. Click on the resource group name

#### 1.2 Delete Resource Group
1. Click **"Delete resource group"**
2. **Confirmation**: Type `rg-on-prem-bootcamp` exactly
3. **Reason for deletion**: Select `"No longer needed"`
4. Click **"Delete"**

**Expected deletion time**: 5-10 minutes

---

### Step 2: Delete Spoke Resource Groups

#### 2.1 Delete Spoke1
1. Navigate to **`rg-spoke1-bootcamp`**
2. Click **"Delete resource group"**
3. Type `rg-spoke1-bootcamp` for confirmation
4. Click **"Delete"**

#### 2.2 Delete Spoke2
1. Navigate to **`rg-spoke2-bootcamp`**
2. Click **"Delete resource group"**
3. Type `rg-spoke2-bootcamp` for confirmation
4. Click **"Delete"**

**Expected deletion time**: 3-5 minutes each

---

### Step 3: Delete Hub Resource Group (Last)

> [!IMPORTANT]
> Delete hub resource group last as it may have dependencies from spoke networks.

#### 3.1 Delete Hub Resources
1. Navigate to **`rg-hub-bootcamp`**
2. Click **"Delete resource group"**
3. Type `rg-hub-bootcamp` for confirmation
4. Click **"Delete"**

**Expected deletion time**: 10-15 minutes (largest resource group)

---

## Method 2: Individual Resource Deletion

### If You Need Selective Cleanup

#### Step 1: Stop All Virtual Machines
1. Navigate to each resource group
2. For each VM, click **"Stop"**
3. Wait for all VMs to show **"Stopped (deallocated)"**

> [!NOTE]
> Stopping VMs immediately stops compute charges but keeps storage costs.

#### Step 2: Delete High-Cost Resources First
Delete in this order to minimize costs:

**FortiGate VMs (Highest Cost):**
1. Delete `hub-fgt-a` and `hub-fgt-b`
2. Delete `on-prem-FGT`

**Other VMs:**
1. Delete `FortiAnalyzer` and `FortiManager`
2. Delete all workload VMs

**Networking:**
1. Delete load balancers
2. Delete public IP addresses
3. Delete network security groups

**Storage:**
1. Delete VM disks
2. Delete storage accounts

#### Step 3: Delete Virtual Networks
1. Delete VNet peerings first
2. Delete virtual networks
3. Delete resource groups when empty

---

## Verification Steps

### Step 1: Verify Resource Group Deletion

#### 1.1 Check Resource Groups List
1. Navigate to **"Resource groups"**
2. Verify these groups are **NOT** listed:
   - `rg-on-prem-bootcamp`
   - `rg-spoke1-bootcamp`
   - `rg-spoke2-bootcamp`
   - `rg-hub-bootcamp`

#### 1.2 Check Deletion Status
1. If groups still appear, check their status
2. Look for **"Deleting"** status
3. Wait for complete removal from list

---

### Step 2: Verify No Hidden Resources

#### 2.1 Search for Bootcamp Resources
1. In Azure Portal search bar, type: `bootcamp`
2. Check **"All resources"** tab
3. Verify no resources contain "bootcamp" in the name

#### 2.2 Check Common Resource Types
Search for these resource types and verify no bootcamp resources remain:
- Virtual machines
- Virtual networks
- Public IP addresses
- Load balancers
- Network security groups

---

### Step 3: Monitor Billing

#### 3.1 Check Cost Analysis
1. Navigate to **"Cost Management + Billing"**
2. Go to **"Cost analysis"**
3. Set date range to include bootcamp period
4. Verify costs stop accruing after deletion

#### 3.2 Review Budget Alerts
1. Check for any budget alerts
2. Monitor daily spend for next few days
3. Ensure costs return to baseline

---

## Troubleshooting Deletion Issues

### Issue: Resource group won't delete
**Common Causes:**
- Active deployments
- Resource locks
- Dependent resources in other subscriptions

**Solutions:**
1. Wait for any active deployments to complete
2. Check for and remove resource locks
3. Delete dependent resources first

### Issue: VNet deletion fails
**Common Causes:**
- Active VNet peerings
- Connected gateways
- Resources still in subnets

**Solutions:**
1. Delete VNet peerings first
2. Remove all resources from subnets
3. Delete subnets before deleting VNet

### Issue: VM deletion hangs
**Solutions:**
1. Force stop the VM first
2. Delete associated disks manually
3. Remove network interfaces separately

---

## Cleanup Verification Checklist

Confirm all items are completed:

**Resource Groups:**
- [ ] `rg-on-prem-bootcamp` deleted
- [ ] `rg-spoke1-bootcamp` deleted
- [ ] `rg-spoke2-bootcamp` deleted  
- [ ] `rg-hub-bootcamp` deleted

**Search Verification:**
- [ ] No resources found searching "bootcamp"
- [ ] No virtual machines with bootcamp names
- [ ] No virtual networks with bootcamp names
- [ ] No public IPs with bootcamp names

**Billing Verification:**
- [ ] Cost analysis shows no new charges
- [ ] Budget alerts (if any) resolved
- [ ] Daily spend returned to baseline

---

## Final Cost Summary

### Bootcamp Total Costs
Assuming 4-6 hours to complete all modules:
- **VM Compute**: $15-25
- **Storage**: $2-5
- **Networking**: $1-3
- **Load Balancers**: $1-2
- **Total Estimated**: $19-35

> [!TIP]
> **Cost Optimization**: The bootcamp was designed to stay well under $50 total cost when completed in a single day and properly cleaned up.

---

## Alternative: Keeping Resources for Learning

### If You Want to Keep Environment Active

**Reduce Costs by:**
1. **Stop (don't delete) VMs when not in use**
   - Stops compute charges
   - Keeps environment for later use
2. **Resize VMs to smaller instances**
   - Change B1s instances to even smaller if available
   - Reduce FortiGate instances to minimum required
3. **Delete non-essential public IPs**
   - Keep only what's needed for access

**Weekly Review:**
- Monitor costs weekly
- Stop unused resources
- Delete when learning is complete

---

## Congratulations!

You have successfully completed the **Fortinet Security Fabric Azure Bootcamp** and properly cleaned up all resources.

### What You Accomplished:
- Built a complete hybrid security fabric
- Learned enterprise security architecture patterns
- Gained hands-on experience with FortiGate, FortiAnalyzer, and FortiManager
- Implemented zero-trust networking principles
- Properly managed cloud resource lifecycle

### Skills Gained:
- Azure networking and security
- FortiGate configuration and management
- High availability design patterns
- Site-to-site VPN implementation
- Centralized logging and management
- Cost optimization and resource management

**Thank you for participating in this comprehensive security bootcamp!**

---

## Additional Resources

For continued learning:
- **Fortinet Documentation**: docs.fortinet.com
- **Azure Architecture Center**: docs.microsoft.com/azure/architecture
- **Fortinet Training**: training.fortinet.com
- **Azure Certifications**: Microsoft Azure security certifications

Remember to apply these skills responsibly and always follow security best practices in production environments.
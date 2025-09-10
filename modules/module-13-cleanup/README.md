# Module 13 - Environment Cleanup

## Overview

This module guides you through removing all bootcamp resources to avoid ongoing Azure charges. Complete deletion in the specified order to prevent dependency issues.

## Cost Impact Warning

### Monthly cost if resources remain active: ~$1,250 USD

- FortiGate VMs: $643/month
- Other VMs: $227/month
- Networking & Storage: $364/month

## Resource Deletion Order

### Step 1: Delete On-Premises Resource Group

1. Navigate to **Resource groups** in Azure Portal
2. Select **`rg-on-prem-bootcamp`**
3. Click **Delete resource group**
4. Type `rg-on-prem-bootcamp` to confirm
5. Click **Delete**

***Deletion time***: *5-10 minutes*

### Step 2: Delete Spoke Resource Groups

Repeat for both spoke resource groups:

**Delete `rg-spoke1-bootcamp`:**

1. Select the resource group
2. Click **Delete resource group**
3. Type `rg-spoke1-bootcamp` to confirm
4. Click **Delete**

**Delete `rg-spoke2-bootcamp`:**

1. Select the resource group
2. Click **Delete resource group**
3. Type `rg-spoke2-bootcamp` to confirm
4. Click **Delete**

***Deletion time***: *3-5 minutes each*

### Step 3: Delete Hub Resource Group (Final)

1. Navigate to **`rg-hub-bootcamp`**
2. Click **Delete resource group**
3. Type `rg-hub-bootcamp` to confirm
4. Click **Delete**

***Deletion time***: *10-15 minutes*

## Alternative: Stop VMs (Keep Environment)

If you plan to continue working with the environment:

1. Navigate to each resource group
2. Stop all VMs (don't delete)
3. VMs must show **"Stopped (deallocated)"**

This stops compute charges while preserving your configuration.

## Verification Checklist

### Confirm Deletion

- [ ] All bootcamp resource groups removed from Resource groups list
- [ ] Search "bootcamp" returns no results in All resources
- [ ] No VMs, VNets, or Public IPs with bootcamp names remain

### Monitor Costs

- [ ] Check Cost Analysis for charge cessation
- [ ] Verify daily spend returns to baseline

## Troubleshooting

**Resource group won't delete:**

- Wait for active deployments to complete
- Remove any resource locks
- Delete dependent resources first

**VM deletion hangs:**

- Force stop VM first
- Delete associated disks manually
- Remove network interfaces separately

### Total Estimated Costs

- **4-6 hour completion**: $8-12 USD
- **8 hours with all resources**: ~15 USD
- **If left running monthly**: ~$1,250 USD

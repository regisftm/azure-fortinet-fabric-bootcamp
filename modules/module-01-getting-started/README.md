# Module 1 - Getting Started

## Azure Environment Setup and Verification

### Overview
Before we begin building our Fortinet Security Fabric, we need to ensure your Azure environment is properly configured. This module will guide you through verifying your subscription access, checking resource quotas, and setting up cost controls.

### Prerequisites
- Active Azure subscription (Pay-as-you-go or Enterprise Agreement)
- Access to Azure Portal (portal.azure.com)
- Basic familiarity with Azure navigation

### Learning Objectives
By the end of this module, you will have:
- Verified your Azure subscription permissions
- Confirmed sufficient resource quotas for the bootcamp
- Set up cost monitoring and alerts
- Created the foundational resource group structure

---

## Step 1: Verify Subscription Access

### 1.1 Log into Azure Portal
1. Navigate to [portal.azure.com](https://portal.azure.com)
2. Sign in with your Azure credentials
3. Once logged in, you should see the Azure Portal dashboard

### 1.2 Identify Your Subscription
1. In the Azure Portal, click on **"Subscriptions"** in the left navigation menu
   - If you don't see it, click on **"All services"** and search for "Subscriptions"
2. Note which subscription you'll be using for this bootcamp
3. **Important**: Ensure you're NOT using a production subscription

### 1.3 Check Subscription Type
1. Click on your subscription name
2. In the **Overview** section, check the **Plan** field:
   - ✅ **Recommended**: Azure Plan, Pay-As-You-Go, Visual Studio, Enterprise Agreement
   - ❌ **Not suitable**: Free Trial (has significant limitations)

### 1.4 Verify Permissions
1. Within your subscription, click on **"Access control (IAM)"**
2. Click **"View my access"**
3. Confirm you have one of these roles:
   - **Owner** (preferred)
   - **Contributor** (minimum required)

> [!WARNING]
> If you don't have Contributor or Owner permissions, contact your Azure administrator before proceeding.

---

## Step 2: Check Resource Quotas

### 2.1 Navigate to Usage + Quotas
1. In your subscription overview, click on **"Usage + quotas"** in the left menu
2. Set the **Provider filter** to **"Microsoft.Compute"**
3. Set the **Location filter** to **"Canada Central"**

### 2.2 Verify Required Quotas
Check that you have sufficient quota for these resources in **Canada Central**:

| Resource Type | Required | Check Location |
|---------------|----------|----------------|
| Standard DSv3 Family vCPUs | 8+ | Search for "Standard DSv3 Family vCPUs" |
| Public IP Addresses | 6+ | Search for "Public IP Addresses - Basic" |
| Standard Public IP Addresses | 4+ | Search for "Public IP Addresses - Standard" |

![verify-quota.screenshot](images/2.2-verify-quotas.png)

### 2.3 Request Quota Increase (If Needed)
If any quotas are insufficient:
1. Click on the quota item
2. Click **"Request increase"**
3. Submit a support request (this may take 1-2 business days)

> [!NOTE]
> Most standard subscriptions have sufficient quotas by default. Free trials may require increases.

---

## Step 3: Set Up Cost Management (optional)

### 3.1 Create a Budget Alert
1. Navigate to **"Cost Management + Billing"**
2. Click on **"Budgets"** under Cost Management
3. Click **"+ Add"**
4. Configure your budget:
   - **Name**: `Fortinet-Bootcamp-Budget`
   - **Amount**: `$50` (buffer above our $30 estimate)
   - **Time period**: Current billing period
   - **Alert conditions**: 80% and 100% of budget

### 3.2 Set Up Budget Alerts
1. In the **Alerts** section:
   - **Alert 1**: 80% threshold → Email notification
   - **Alert 2**: 100% threshold → Email notification
2. Enter your email address for notifications
3. Click **"Create"**

---

## Step 4: Create Resource Group Structure

### 4.1 Create Hub Resource Group
1. Navigate to **"Resource groups"**
2. Click **"+ Create"**
3. Configure the resource group:
   - **Subscription**: Your selected subscription
   - **Resource group name**: `rg-hub-bootcamp`
   - **Region**: `Canada Central`
4. Click **"Review + create"** then **"Create"**

![resource-group-creation.animation](images/4.1-resource-group-creation.gif)

### 4.2 Create Spoke Resource Groups
Repeat the process to create two more resource groups:

1. **Second Resource Group**:
   - **Name**: `rg-spoke1-bootcamp`
   - **Region**: `Canada Central`

2. **Third Resource Group**:
   - **Name**: `rg-spoke2-bootcamp`
   - **Region**: `Canada Central`

---

## Step 5: Environment Verification Checklist

Before proceeding to Module 2, verify you have completed:

- [ ] Confirmed subscription access with Contributor or Owner role
- [ ] Verified sufficient quotas in Canada Central region
- [ ] Set up budget monitoring with email alerts
- [ ] Created three resource groups:
  - `rg-hub-bootcamp`
  - `rg-spoke1-bootcamp`
  - `rg-spoke2-bootcamp`

---

## Troubleshooting Common Issues

### Issue: Can't see Subscriptions menu
**Solution**: You may not have sufficient permissions. Contact your Azure administrator.

### Issue: Quota limits are too low
**Solution**: Submit a quota increase request through the Azure Portal. This typically takes 1-2 business days.

### Issue: Can't create resource groups
**Solution**: Verify you have Contributor permissions at the subscription level.

---

## Next Steps

Once you've completed this module and verified all prerequisites, you're ready to proceed to [**Module 2: Hub Network Infrastructure Setup**](../module-02-hub-setup/README.md).

**Estimated completion time**: 15-20 minutes

> [!TIP]
> Keep the Azure Portal open in a separate browser tab throughout the bootcamp for easy navigation between modules.
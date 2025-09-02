# Fortinet Security Fabric Azure Bootcamp

## From Edge to Cloud: Building resilient Azure security with hybrid connectivity

### Welcome!

Organizations need resilient security solutions that protect both cloud and on-premises assets while maintaining operational continuity. This bootcamp provides practical skills for building enterprise-ready security infrastructure that ensures high availability, centralized visibility, and seamless connectivity across hybrid environments. You'll gain hands-on experience with real-world deployment scenarios critical for modern cybersecurity professionals by building a complete security fabric featuring high-availability FortiGate clusters, with FortiManager and FortiAnalyzer, and hybrid connectivity.

### Time Requirements

The estimated time to complete this bootcamp is 90-120 minutes.

### Target Audience

- Cloud security engineers and architects
- Network security professionals transitioning to cloud
- Fortinet administrators expanding to Azure
- DevOps/SecOps engineers managing hybrid environments
- IT professionals implementing enterprise security solutions
- Security consultants and presales engineers
- System administrators responsible for firewall management

**Experience Level**: Intermediate to advanced professionals with networking fundamentals and basic Azure knowledge.

### What You'll Learn:

- Deploy FortiGate firewalls in Active-Passive HA configuration using Azure Load Balancers
- Configure FortiAnalyzer for centralized logging and analytics
- Set up FortiManager for unified policy management
- Establish secure site-to-site VPN connectivity between on-premises and Azure environments
- Implement best practices for cloud security architecture and hybrid networking

## Modules

This bootcamp is organized in sequential modules. One module will build up on top of the previous module, so please, follow the order as proposed below.

Module 1 - [Getting Started: Azure Environment Setup and Verification](/modules/module-01-getting-started/README.md)    
Module 2 -   

---

> [!NOTE]
> The workshop provides examples and sample code as instructional content for you to consume. These examples will help you understand how to configure Calico Cloud and build a functional solution. Please note that these examples are not suitable for use in production environments.

> [!WARNING] 
> If you are using a subscription in your production environment, it would be more prudent not to use your "Global Admin" account. Although the lab is designed to function in "isolated" mode, a "human" error when creating certain resources ("peering", routing table, ...) could impact your production environment. We recommend using your standard account on an isolated subscription.

> [!CAUTION] 
> This lab uses several virtual machines. The entire lab should stay under $30. At the end of the day, it will be important to delete everything or at least stop the VMs if you don't want any unpleasant surprises.
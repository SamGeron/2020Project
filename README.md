
# 2020Projects

### In this GitHub repository you will see my Cyber Security projects from this year, including:
1. Azure Virtual Network topologies
2. Some Ansible YAML playbooks
3. Some Linux bash scripts
4. My login solution to the HackTheBox PenTesting training grounds  

## **Azure Topology**

### **Virtual Network Topology with ELK**

![alt text](https://github.com/SamGeron/2020Projects/blob/main/Diagrams/Cloud_Security_ELK.png "Azure Virtual Network with ELK Stack")

 
This is the topology for an Azure cloud environment including an ELK Stack, JumpBox and 3 Web VMs. The host machine accesses the Jumpbox virtual machine through the JumpBox Public IP 20.193.74.114, though this IP may change, but can be confirmed through the Virtual Machine settings. The host machine’s IP is added as an inbound Network Security Group rule, in this case at rule 100, as an ssh entry point, prior to the 65500 DenyAllInBound. The JumpBox has been assigned IP 10.0.0.9 in the subnet. From the JumpBox, we can access all the other machines within the Virtual Network, the 3 Web VMs – in this case 10.0.0.7, 10.0.0.10, 10.0.0.11 and our ELK machine 10.1.0.4. The 3 Web VMs sit behind a Load Balancer, and access the outside world through the Load Balancer’s Public IP 13.75.172.180.  By using our Docker container Ansible, we can load all our other VM environments with our YAML scripts. On the 3 Web VMs we have the DVWA – the Damn Vulnerable Web Application, with redundancies in place (having 3 VMs rather than just one). On the ELK machine we can load Kibbana through the browser through port 5601.
There are two Network Security Groups – RedNet Security that manages overarching rules for access to the Virtual Network, more specifically allowing ssh access to the JumpBox, which is located within Australia East, and ELK NSG to manage access for the ELK Stack, which is located in Australia Central.
| Virtual Machine| Subnet IP | Public IP | Network Security Group |
| :-------------:|:-------------:| :-----:| :--: |
| JumpBox | 10.0.0.9 | 20.193.74.114 | RedNet Security |
| Web 1 | 10.0.0.7  | 13.75.172.180 | RedNet Security |
| Web 2 | 10.0.0.10 | 13.75.172.180 | RedNet Security |
| Web 3 | 10.0.0.11 | 13.75.172.180 | RedNet Security |
| ELK | 10.1.0.4 | 20.37.249.110 | ELK NSG |

### **Here we have the original topology without the ELK VM:**

![alt text](https://github.com/SamGeron/2020Projects/blob/main/Diagrams/Cloud_Security.png "Azure Virtual Network basic")
 




# 2020Projects

Azure Topology

This is the topology for an Azure cloud environment. The host machine accesses the Jumpbox virtual machine through the JumpBox Public IP 20.193.74.114, though this IP may change, but can be confirmed through the Virtual Machine settings. The host machine’s IP is added as an inbound Network Security Group rule, in this case at rule 100, as an ssh entry point, prior to the 65500 DenyAllInBound. The JumpBox has been assigned IP 10.0.0.9 in the subnet. From the JumpBox, we can access all the other machines within the Virtual Network, the 3 Web VMs – in this case 10.0.07, 10.0.0.10, 10.0.0.11 and our ELK machine 10.1.0.4. The 3 Web VMs sit behind a Load Balancer, and access the outside world through the Load Balancer’s Public IP 13.75.172.180.  By using our Docker container Ansible, we can load all our other VM environments with our YAML scripts. On the 3 Web VMs we have the DVWA – the Damn Vulnerable Web Application, with redundancies in place (having 3 VMs rather than just one). On the ELK machine we can load Kibbana through the browser through port 5601.
There are two Network Security Groups – RedNet Security that manages overarching rules for access to the Virtual Network, more specifically allowing ssh access to the JumpBox, which is located within Australia East, and ELK NSG to manage access for the ELK Stack, which is located in Australia Central.

Ansible Scripts

Included in this GitHub repo are playbooks - yaml scripts, to automate setup and deployment for VMs with: Metricbeat (to collect metrics); Filebeat (to monitor logs); ELK (to collect data for analysis); Web VM docker setup (to configure docker on the Web VMs with DVWA for Pen Testing purposes); as well as Docker Compose for multi-container deployment. All yaml scripts easily automate quick setup and take-down with Ansible.

Linux Bash Scripts

Here are some simple bash scripts for isolating data and events from logs. Here we have the scenario of casino dealers and players colluding to steal money by cheating in from three casino games, in particular a Roulette table suffering irregular losses. The scripts included correlate the unusual loss events/times, with the roulette dealers and players at those particular times. The scripts analyse events that have happened, as well as scripts that can be used for similar future events.




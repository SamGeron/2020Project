
# 2020Projects

### In this GitHub repository you will see my Cyber Security projects from this year, including:
1. Azure Virtual Network topologies
2. Ansible YAML playbooks
3. [Linux bash scripts](https://github.com/SamGeron/2020Projects/tree/main/Linux) 
4. [My login solution](https://github.com/SamGeron/2020Projects/tree/main/HacktheBox) to the HackTheBox PenTesting training grounds  
5. [Final Project Report](https://github.com/SamGeron/2020Projects/blob/main/Final%20Project%20Report.pdf) -  involves managing both the Red Team penetration test and the Blue Team defence and system hardening

## **Azure Topology**

### **Virtual Network Topology with ELK**

![alt text](https://github.com/SamGeron/2020Projects/blob/main/images/Cloud_Security_ELK.png "Azure Virtual Network with ELK Stack")

 
This is the topology for an Azure cloud environment including an ELK Stack, JumpBox and 3 Web VMs. The host machine accesses the Jumpbox virtual machine through the JumpBox Public IP, as a dynamic IP it will often change and need to be checked at the beginning of each session and can be confirmed through the Virtual Machine settings. The host machine’s IP is added as an inbound Network Security Group rule, in this case at rule 100, as an ssh entry point, prior to the 65500 DenyAllInBound. The JumpBox has been assigned IP 10.0.0.9 in the subnet. From the JumpBox, we can access all the other machines within the Virtual Network, the 3 Web VMs – in this case 10.0.0.7, 10.0.0.10, 10.0.0.11 and our ELK machine 10.1.0.4. The 3 Web VMs sit behind a Load Balancer, and access the outside world through the Load Balancer’s Public IP.  By using our Docker container Ansible, we can load all our other VM environments with our YAML scripts. On the 3 Web VMs we have the DVWA – the Damn Vulnerable Web Application, with redundancies in place (having 3 VMs rather than just one). On the ELK machine we can load Kibbana through the browser through port 5601.
There are two Network Security Groups – RedNet Security that manages overarching rules for access to the Virtual Network, more specifically allowing ssh access to the JumpBox, which is located within Australia East, and ELK NSG to manage access for the ELK Stack, which is located in Australia Central.
| Virtual Machine| Subnet IP | Public IP | Network Security Group |
| :-------------:|:-------------:| :-----:| :--: |
| JumpBox | 10.0.0.9 | dynamic IP xxx.xxx.xxx | RedNet Security |
| Web 1 | 10.0.0.7  | load balancer dynamic IP xxx.xxx.xxx | RedNet Security |
| Web 2 | 10.0.0.10 | load balancer dynamic IP xxx.xxx.xxx | RedNet Security |
| Web 3 | 10.0.0.11 | load balancer dynamic IP xxx.xxx.xxx | RedNet Security |
| ELK | 10.1.0.4 | dynamic IP xxx.xxx.xxx | ELK NSG |

### **Here we have the original topology without the ELK VM:**

![alt text](https://github.com/SamGeron/2020Projects/blob/main/images/Cloud_Security.png "Azure Virtual Network basic")
 




## **Ansible Scripts**

Included in this GitHub repo are playbooks - yaml scripts, to automate setup and deployment for VMs with: Metricbeat (to collect metrics); Filebeat (to monitor logs); ELK (to collect data for analysis); Web VM docker setup (to configure docker on the Web VMs with DVWA for Pen Testing purposes); as well as Docker Compose for multi-container deployment. All yaml scripts easily automate quick setup and take-down with Ansible.

### **Metricbeat**
```
---
- name: Install metric beat
  hosts: webservers
  become: true
  tasks:
    # Use command module
  - name: Download metricbeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb

    # Use command module
  - name: install metricbeat
    command: dpkg -i metricbeat-7.4.0-amd64.deb

    # Use copy module
  - name: drop in metricbeat config
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/ansible/metricbeat

    # Use command module
  - name: enable and configure docker module for metric beat
    command: metricbeat modules enable docker

    # Use command module
  - name: setup metric beat
    command: metricbeat setup

    # Use command module
  - name: start metric beat
    command: metricbeat -e
```


### Filebeat

```
---
- name: Installing and Launch Filebeat
  hosts: webservers
  become: yes
  tasks:
    # Use command module
  - name: Download filebeat .deb file
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

    # Use command module
  - name: Install filebeat .deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

    # Use copy module
  - name: Drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-configuration.yml
      dest: /etc/filebeat/filebeat.yml

    # Use command module
  - name: Enable and Configure System Module
    command: filebeat modules enable system

    # Use command module
  - name: Setup filebeat
    command: filebeat setup

    # Use command module
  - name: Start filebeat service
    command: service filebeat start
```

### ELK Install

```
---
- name: Configure Elk VM with Docker
  hosts: elk
  remote_user: azadmin
  become: true
  tasks:
    # Use apt module
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present

      # Use apt module
    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

      # Use pip module (It will default to pip3)
    - name: Install Docker module
      pip:
        name: docker
        state: present

      # Use command module
    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144

      # Use sysctl module
    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes

      # Use docker_container module
    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        # Please list the ports that ELK runs on
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044
```

### Web VMs Docker Setup with DVWA

```
---
- name: Config Web VM with Docker
  hosts: webservers
  become: true
  tasks:
    - name: docker.io
      apt:
        update_cache: yes
        name: docker.io
        state: present

    - name: Install pip3
      apt:
        name: python3-pip
        state: present

    - name: Install Docker python module
      pip:
        name: docker
        state: present

    - name: download and launch a docker web container
      docker_container:
        name: dvwa
        image: cyberxsecurity/dvwa
        state: started
        restart_policy: always
        published_ports: 80:80

    - name: Enable docker service
      systemd:
        name: docker
        enabled: yes
```



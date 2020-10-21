
# 2020Projects

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


## Linux Bash Scripts

Here are some simple bash scripts for isolating data and events from logs. Here we have the scenario of casino dealers and players colluding to steal money by cheating from within three possible casino games, in particular a Roulette table has been suffering irregular losses. The scripts included correlate the unusual loss events/times, with the roulette dealers and players at those particular times. The scripts analyse existing log events; as well there’s a script that can be used for analysis of future events. These scripts essentially focus on grep and awk commands that correlate with the log data layout.

### Log Data for Analysis

##### Loss Times Player Data
###### 0310_win_loss_player_data:05:00:00 AM	-$82,348	Amirah Schneider,Nola Portillo, Mylie Schmidt,Suhayb Maguire,Millicent Betts,Avi Graves
###### 0310_win_loss_player_data:08:00:00 AM	-$97,383	Chanelle Tapia, Shelley Dodson , Valentino Smith, Mylie Schmidt
###### 0310_win_loss_player_data:02:00:00 PM	-$82,348	Jaden Clarkson, Kaidan Sheridan, Mylie Schmidt 
###### 0310_win_loss_player_data:08:00:00 PM	-$65,348        Mylie Schmidt, Trixie Velasquez, Jerome Klein ,Rahma Buckley
###### 0310_win_loss_player_data:11:00:00 PM	-$88,383	Mcfadden Wasim, Norman Cooper, Mylie Schmidt
###### 0312_win_loss_player_data:05:00:00 AM	-$182,300	Montana Kirk, Alysia Goodman, Halima Little, Etienne Brady, Mylie Schmidt
###### 0312_win_loss_player_data:08:00:00 AM	-$97,383        Rimsha Gardiner,Fern Cleveland, Mylie Schmidt,Kobe Higgins	
###### 0312_win_loss_player_data:02:00:00 PM	-$82,348        Mae Hail,  Mylie Schmidt,Ayden Beil	
###### 0312_win_loss_player_data:08:00:00 PM	-$65,792        Tallulah Rawlings,Josie Dawe, Mylie Schmidt,Hakim Stott, Esther Callaghan, Ciaron Villanueva	
###### 0312_win_loss_player_data:11:00:00 PM	-$88,229        Vlad Hatfield,Kerys Frazier,Mya Butler, Mylie Schmidt,Lex Oakley,Elin Wormald	
###### 0315_win_loss_player_data:05:00:00 AM	-$82,844        Arjan Guzman,Sommer Mann, Mylie Schmidt	
###### 0315_win_loss_player_data:08:00:00 AM	-$97,001        Lilianna Devlin,Brendan Lester, Mylie Schmidt,Blade Robertson,Derrick Schroeder	
###### 0315_win_loss_player_data:02:00:00 PM	-$182,419        Mylie Schmidt, Corey Huffman

#### Loss Times Dealer Data
###### Hour AM/PM	BlackJack_Dealer_FNAME LAST	Roulette_Dealer_FNAME LAST	Texas_Hold_EM_dealer_FNAME LAST

###### 12:00:00 AM	Izabela Parrish	Marlene Mcpherson	Madina Britton
###### 01:00:00 AM	Billy Jones	Saima Mcdermott	Summer-Louise Hammond
###### 02:00:00 AM	Summer-Louise Hammond	Abigale Rich	John-James Hayward
###### 03:00:00 AM	John-James Hayward	Evalyn Howell	Chyna Mercado
###### 04:00:00 AM	Chyna Mercado	Cleveland Hanna	Katey Bean
###### 05:00:00 AM	Katey Bean	Billy Jones	Evalyn Howell
###### 06:00:00 AM	Evalyn Howell	Saima Mcdermott	Cleveland Hanna
###### 07:00:00 AM	Cleveland Hanna	Abigale Rich	Billy Jones
###### 08:00:00 AM	Rahima Figueroa	Billy Jones	Madina Britton
###### 09:00:00 AM	Marlene Mcpherson	Cleveland Hanna	Summer-Louise Hammond
###### 10:00:00 AM	Izabela Parrish	Madina Britton	John-James Hayward
###### 11:00:00 AM	Madina Britton	Summer-Louise Hammond	Chyna Mercado
###### 12:00:00 PM	Summer-Louise Hammond	John-James Hayward	Katey Bean
###### 01:00:00 PM	John-James Hayward	Chyna Mercado	Evalyn Howell
###### 02:00:00 PM	Chyna Mercado	Billy Jones	Cleveland Hanna
###### 03:00:00 PM	Katey Bean	Evalyn Howell	Rahima Figueroa
###### 04:00:00 PM	Evalyn Howell	Cleveland Hanna	Billy Jones
###### 05:00:00 PM	Billy Jones	Rahima Figueroa	Summer-Louise Hammond
###### 06:00:00 PM	Rahima Figueroa	John-James Hayward	John-James Hayward
###### 07:00:00 PM	Marlene Mcpherson	Chyna Mercado	Chyna Mercado
###### 08:00:00 PM	Saima Mcdermott	Billy Jones	Katey Bean
###### 09:00:00 PM	Abigale Rich	Evalyn Howell	Billy Jones
###### 10:00:00 PM	Evalyn Howell	Katey Bean	Cleveland Hanna
###### 11:00:00 PM	Cleveland Hanna	Billy Jones	Rahima Figueroa

The following script will manually pull the Roulette loss event dealer's name that was working at 05:00:00 AM on the 3rd of March, and appending the output to the investigation file "Dealers_Working_During_Losses". Each entry will be labelled with the date. The date can be adjusted by changing the date being labelled and changing log file date being accessed. The time can also be adjusted in the script. Alternatively, a collection of scripts of times and calendar days can be made to access this type of data.

```
#!/bin/bash/
#
#Just assign time and date
#
echo "Date: 0310" >> Dealers_Working_During_Losses
cd ~/Casino_Theft_Investigations/Roulette_Loss_Investigation/Dealer_Analysis
grep "05:00:00 AM" 0310_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}' >> Dealers_Working_During_Losses
```

The following script will be able to pull any day and time as explained in the script. Regardless of the filename, providing they are logged systematically starting with day/month or vice versa, the user need on input into the command line: day/month (0310), time (05:00:00), AM or PM (AM), and the output will provide the time and name of the dealer. Multiple days could be searched at once in this way (eg. 03* would search all of May), although these entries won't as yet identify the days. 

```
#!/bin/bash
# cat $1* for the date for example 0310 for March 10, $2 for the time eg. 05:00:00, $3 for AM or PM
# grep will isolate the correct line from the log data
# awk will print the field data - time and name. eg. 05:00:00 AM Billy Jones 
cat $1* | grep $2 | grep $3 |  awk -F" " '{print $1, print $2, print $5, print$6}'
```


## Linux Bash Scripts

Here are some simple bash scripts for isolating data and events from logs. Here we have the scenario of an investigation for a casino losing unusual amounts of money, that casino dealers and players may be colluding to steal money by cheating from within three possible casino games, in particular specific illegitimate losses have been identified at a Roulette table. The scripts included correlate the unusual loss events/times, with the roulette dealers and players at those particular times. The scripts analyse existing log events; as well there’s a script that can be used for analysis of future events. These scripts essentially focus on grep and awk commands that correlate with the log data layout.

### Log Data for Analysis

#### Loss Times Player Data
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
###### (example of the 3rd of March)
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


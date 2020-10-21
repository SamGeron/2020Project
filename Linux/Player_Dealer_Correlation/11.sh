#!/bin/bash/
#
#Just assign time and date
#
echo "Date: 0315" >> Dealers_Working_During_Losses
cd ~/Unit_3_Assignment/Lucky_Duck_Investigations/Roulette_Loss_Investigation/Dealer_Analysis
grep "05:00:00 AM" 0315_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}' >> Dealers_Working_During_Losses
#
#
#LOSS TIMES
#
#7-0312_win_loss_player_data:08:00:00 AM
#8-0312_win_loss_player_data:02:00:00 PM
#9-0312_win_loss_player_data:08:00:00 PM
#10-0312_win_loss_player_data:11:00:00 PM
#11-0315_win_loss_player_data:05:00:00 AM
#12-0315_win_loss_player_data:08:00:00 AM
#13-0315_win_loss_player_data:02:00:00 PM
#

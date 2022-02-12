#! /bin/bash

red="\033[1;031m"
green="\033[1;032m"
normal="\033[0m"

# main menu function ---------------------------------------------------------------------------# main menu

function main_menu() {
	clear

	# assinging variables....	
	PS3=" Enter your choice : "
  	local option
  	
	show_main_menu;
	sleep 1

	# load_screens ---------
	read -p "choose option : " option
	loading_screen;

	if [[ $option == 1 ]]
	then
		create_player;
	elif [[ $option == 2 ]]
	then
		list_players;
	elif [[ $option == 0 ]]
	then
		exit
	fi
}


# show_main memu ----------------------------------------------------------------------------- # show main menu

function show_main_menu() {

	echo -e "\t \t \t \t \t \t \t \t     Welcome "
	echo -e "\n \n \n \n  "
	echo -e  "\t\t\t\t\t\t\t\t 1->  NEW GAME "
	echo -e "\n \n  "
	echo -e  "\t\t\t\t\t\t\t\t 2->  CONTINUE "
	echo -e "\n \n  "
	echo -e  "\t\t\t\t\t\t\t\t 0->  EXIT "
	echo -e "\n\n\n\n\n\n\n\n\n"

}

#loading screen----------------------------------------------------------------------------------# loadin screen

function loading_screen() {
	clear
	echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t\t\t\t  .LOADING."
	sleep 1
	clear
	echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t\t\t\t ..LOADING.."
	sleep 1
	clear
	echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t\t\t\t...LOADING..."
	sleep 1
	clear
}

# create_player----------------------------------------------------------------------------------# create player

function create_player() {
	clear

	#player_creation
	echo -e "\n \n \n \n  "
	read -p " Enter player name : " player_name

	# check if player exists or not
	if [[ -e players/$player_name ]]
	then
		echo -e "\n"
		echo -e "\t player already exists"
		sleep 2
		create_player;
	else
		echo -e "\t \t\t creating new profile...."
		sleep 3
		touch players/$player_name
		
		# Assigning stats
		echo -e "\n\n"
		echo -e "\t\t\t The basic stats will be given "

		sleep 3
			
		HP=20
		ATK=10
		DEF=10
		clear

		# load other scenes
		loading_screen;
		show_stats;

	fi

}

# Listing of players --------------------------------------------------------------------------------# Listing of players

function list_players() {
	clear
		
	local file
		
	check_profiles;
	
	# listing players
	cd players
	
	echo -e "\t\t\t\t Select your profile "
	echo -e "\n\n\n\n"
	select file in * ; do break ; done
	sleep 1
		
	# get details of player stats
	player_name=$file
	HP=`cat $file | grep -i HP | cut -f2 -d"|"`
	ATK=`cat $file | grep -i ATK | cut -f2 -d"|"`
	DEF=`cat $file | grep -i DEF | cut -f2 -d"|"`
	
	cd ..
		
	# loading profile
	echo -e "\n\n\t\t\t\t Loading Profile" 
	sleep 2

	loading_screen;
	show_stats;
	clear

}

# check profiles ------------------------------------------------------------------------------------------# check profiles

function check_profiles() {

	local players_list=`ls players`
	
	if [[ -z $players_list ]]
	then
		
		echo -e "\n\n\n\n\t\t\t\t No Players Found \n\n\n\t\t\t\t\t Returning to Main Menu "
		sleep 2
		main_menu;
		return 1;
	fi
	
}

# Show stats of the player ---------------------------------------------------------------------------------# stats

function show_stats() {
	clear
	
	# prinitng the stats	
	echo -e "\t \t \t \t \t \t \t         Player : ${player_name} "
	echo -e "\n \n \n \n  "
	echo -e  "\t\t\t\t\t\t\t\t -- > HP  : $HP "
	echo -e "\n \n  "
	echo -e  "\t\t\t\t\t\t\t\t -- > ATK : $ATK "
	echo -e "\n \n  "
	echo -e  "\t\t\t\t\t\t\t\t -- > DEF : $DEF "
	
	sleep 5
	
	# updating stats
	update_stats;
	level_selection;	
	clear
	
}

# updation of stats ----------------------------------------------------------------------------------------------# update stats

function update_stats() {
	cd players;
		
	echo -e " player |$player_name\n" > $player_name
	echo -e " HP |$HP\n" >> $player_name
	echo -e " ATK |$ATK\n" >> $player_name
	echo -e " DEF |$DEF\n" >> $player_name
	
	cd ..;
}

# level selection --------------------------------------------------------------------------------------------# level selection

function level_selection()
{

	clear
	echo "player: $player_name" 
	show_warning_message;
		
	# Selection of level
	
	cd levels;
	select level in * ; do break; done
	cd ..
	sleep 2
			
	echo -e "\n\n"
	echo  " Entering $level "
	sleep 2	
	
	# load screens
	
	if [[ -z $level ]] 
	then
		main_menu;
		return 0;
	fi
	
	loading_screen;
	load_level;

}

# show warning message ----------------------------------------------------------------------------------------------# show warning message

function show_warning_message() {

	echo -e "\n\n\n"
	echo -e "\t \t \t Please select based on your stats, After entering a level theres no coming back, Good Luck!"
	echo -e "\t \t \t \t \t \t Press 0 to exit to mainscreen "
	
	
	echo -e "\n\n"
	echo -e "\t\t\t For every enemy you kill, Your health will decrease by 1, \n\t\t\t Your stats will increase when u clear a level \n\n\n\n"
	
}

# load selected level -----------------------------------------------------------------------------------------------# load selected level

function load_level() {
	clear
	
	echo -e "player: $player_name \n\n\n\n\n\n\n\n\n "
	echo -e "\t\t\t\t\t\t\t\t level : $level Loaded, Good Luck " 
	sleep 2
			
	attack_level;	

}

# Attacking scenario -------------------------------------------------------------------------------------------------------# attack scenario

function attack_level() {
	clear
	
	get_enemy_stats;
			
	original_HP=$HP
	Defend=3
	
	# Interactive part  -----------
	
	while [[ $enemies_count != 0 ]]
	do 
		clear
		show_instructions;
		read -p " choose action : " action
						
		if [[ $action == "A" ]]
		then
			perform_attack;
		fi
				
		if [[ $action == "D" ]]
		then 
			perform_defend;
		fi
		
		check_if_game_ends;

	done
}

# show instructions-----------------------------------------------------------------------------------------------------------------# show instructions

function show_instructions() {

	echo " player : $player_name "
	cat instruction
	echo -e "\n"
	echo -e "Remaining enemies : $enemies_count \t\t\t\t  Player Health : $HP \t\t\t Defend : $Defend" 
		
}

# get enemy stats ----------------------------------------------------------------------------------------------------------------# enemy stats

function get_enemy_stats() {
		
	cd levels
	
	enemies_count=`cat $level | grep -i count | cut -f2 -d"|"`
	enemy_type=`cat $level | grep -i type | cut -f2 -d"|"`
	enemy_ATK=`cat $level | grep -i atk | cut -f2 -d"|"`
	enemy_HP=`cat $level | grep -i hp | cut -f2 -d"|"`

	cd ..
	
}

# perform attack ---------------------------------------------------------------------------------------------------------------# perform attack

function perform_attack() {

	if [[ $ATK -ge $enemy_HP ]]
	then
		
		echo " you have inflicted $ATK damage on enemy"
		echo " you have taken $enemy_ATK damage "
		HP=$(( $HP-1 ))
		echo -e " enemy died \n"
		sleep 2
		enemies_count=$(( $enemies_count - 1 ))
	
	else
		
		echo " you have inflicted $ATK damage "
		echo " enemy overpowers you "
		echo " you have died "
		echo " returning to level selection"
		sleep 3
		level_selection;
		return 0;
	fi
}

# perform defend -------------------------------------------------------------------------------------------------------------# perform defend

function perform_defend() {

	if [[ $Defend > 0 ]]
	then
		echo " You have defended $enemy_ATK damage "
		Defend=$(( $Defend - 1 ))
		HP=$(( $HP + 1 ))
		echo " You have restored 1 HP "
		sleep 2
	else
		echo -e " \n Your defence stat is exhausted "			
		sleep 2
	fi
}

# level cleared -----------------------------------------------------------------------------------------------------------------# level cleared

function level_cleared() {
	
	echo -e "\n\n\t\t\t You have cleared the level \n\n\t\t\t Your stats have grown"
	HP=$(( $original_HP + 5 ))
	ATK=$(( $ATK + 5 ))
	DEF=$(( $DEF + 5 ))
	sleep 3
	show_stats;
	return 0;

}

# loop breaks/game alternate ending ------------------------------------------------------------------------------------------# loop/game ends

function check_if_game_ends() {

	if [[ $enemies_count == 0 ]]
	then
		level_cleared;
	fi
	
	if [[ $player_health == 0 ]]
	then
		echo -e "\n\t Your health is 0, You have died \n\n\n\t Returning to level selection"
		level_selection;
		return 0;
	fi
	
}

main_menu ;




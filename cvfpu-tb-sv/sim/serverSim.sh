#!/bin/bash
# Check if the user requests help
if [[ "$1" == "--help" ||  $# -lt 3 ]]; then
  echo "Usage: $0 <local_folder> <remote_folder> <simulation_script_name>"
  echo
  echo "This script synchronizes the local repository with the remote repository on the server using rsync"
  echo "and then executes a simulation script on the remote server."
  echo "It retrieves the simulation output file from the remote server and copies it to the local folder."
  echo
  echo "Example:"
  echo "  $0 /path/to/local/folder   /path/to/remote/folder simulation_script_name"
  echo "In the main folder of the project (for example reg-tb):"
  echo "  ./sim/serverSim.sh /home/riccardo/git/isa/verification/mantissa-tb-sv /home/isa09_2023_2024/lab4/mantissa-tb-sv sim.sh"
  exit 0
fi

local_folder="$1"
remote_folder="$2"
remote_script="$3"
output_file="report-sim.log"

#####################################################################################
# SSH Settings
#####################################################################################

ssh_username="isa09_2023_2024"
ssh_password="isagoofy"
ssh_port="10038"
server_address="led-x3850-2.polito.it"

#####################################################################################
# Folders Settings
#####################################################################################

# Sync local folder with server
rsync -avz --delete -e "sshpass -p $ssh_password ssh -p $ssh_port" $local_folder/ $ssh_username@$server_address:$remote_folder/
# Execute script on server and retrieve output file
sshpass -p $ssh_password ssh -p $ssh_port  $ssh_username@$server_address "source /eda/scripts/init_questa_core_prime && cd $remote_folder/sim && ./$remote_script  && rm -r work "
sshpass -p $ssh_password scp -P $ssh_port $ssh_username@$server_address:$remote_folder/sim/$output_file $local_folder/sim
sshpass -p $ssh_password scp -P $ssh_port $ssh_username@$server_address:$remote_folder/sim/report-cov.log $local_folder/sim



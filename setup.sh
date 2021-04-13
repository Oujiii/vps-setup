#!/bin/bash

set -e

# Check if a few common applications are installed
# Exit showing the way to solve if they aren't
function checkApps() {
   DEPEN="$(command -v curl && command -v htop && command -v screen && command -v git && command -v sudo && command -v ufw)"
    [ $? -ne 0 ] && {
	    echo "Are you using Debian or Ubuntu Minimal? If so, run first.sh before running this script" ;
	    exit 1 ;
		}      
}

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/setupLibrary.sh"
}

current_dir=$(getCurrentDir)
includeDependencies
output_file="output.log"

function main() {
    read -rp "Enter the username of the new user account:" username

    promptForPassword

    # Run setup functions
    trap cleanup EXIT SIGHUP SIGINT SIGTERM

    addUserAccount "${username}" "${password}"

    read -rp $'Paste in the public SSH key for the new user:\n' sshKey
    logTimestamp "${output_file}"

    read -rp "Paste your ZT network ID:" ztid
    read -rp "Paste your TS pre-auth key:" tskey
    
    exec 3>&1 >>"${output_file}" 2>&1
    disableSudoPassword "${username}"
    addSSHKey "${username}" "${sshKey}"
    changeSSHConfig
    installZT-TS
    setupZT-TS "${ztid}" "${tskey}"
    echo 'Running setup script...'
    setupUfw

    if ! hasSwap; then
        setupSwap
    fi

    setupTimezone

    echo "Installing Network Time Protocol... " >&3
    configureNTP

    sudo service ssh restart

    cleanup

    echo "Setup Done! Log file is located at ${output_file}" >&3
}

function setupSwap() {
    createSwap
    mountSwap
    tweakSwapSettings "10" "50"
    saveSwapSettings "10" "50"
}

function hasSwap() {
    [[ "$(sudo swapon -s)" == *"/swapfile"* ]]
}

#function cleanup() {
#    if [[ -f "/etc/sudoers.bak" ]]; then
#        revertSudoers
#    fi
#}

function logTimestamp() {
    local filename=${1}
    {
        echo "===================" 
        echo "Log generated on $(date)"
        echo "==================="
    } >>"${filename}" 2>&1
}

function setupTimezone() {
    echo -ne "Enter the timezone for the server (Default is 'America/Sao_Paulo'):\n" >&3
    read -r timezone
    if [ -z "${timezone}" ]; then
        timezone="America/Sao_Paulo"
    fi
    setTimezone "${timezone}"
    echo "Timezone is set to $(cat /etc/timezone)" >&3
}

# Keep prompting for the password and password confirmation
function promptForPassword() {
   PASSWORDS_MATCH=0
   while [ "${PASSWORDS_MATCH}" -eq "0" ]; do
       read -s -rp "Enter new UNIX password:" password
       printf "\n"
       read -s -rp "Retype new UNIX password:" password_confirmation
       printf "\n"

       if [[ "${password}" != "${password_confirmation}" ]]; then
           echo "Passwords do not match! Please try again."
       else
           PASSWORDS_MATCH=1
       fi
   done 
}

main

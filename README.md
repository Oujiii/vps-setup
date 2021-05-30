# Bash setup script for Linux (Debian-based) servers

Want to run without Tailscale? Clone the `open` branch instead. Zerotier support can be found on the `zerotier` branch.

This is a setup script to automate the setup and provisioning of Linux (Debian-based) servers. It does the following:
* Adds a new user account with sudo access
* Adds a public ssh key for the new user account
* Disables password authentication to the server
* Deny root login to the server
* Install Tailscale
* Setup Tailscale network
* Setup Uncomplicated Firewall with rules to allow SSH only from the Tailscale interface
* Create Swap file based on machine's installed memory
* Setup the timezone for the server (Default to "America/Sao_Paulo")
* Install Network Time Protocol

`first.sh`
* Installs curl htop screen sudo ufw in case the server does not have those yet.

`ufw-fix.sh`
* Only required on Debian 10 (Buster). Changes `iptables-nft` to `iptables-legacy`. `iptables-nft` breaks `ufw` on the Debian Buster installs I tried it on.

`docker.sh`
* Installs docker, docker-compose and ufw-docker (a tool to fix ufw/docker integration)

# Installation
SSH into your server and install git if it is not installed:
```bash
sudo apt-get update
sudo apt-get install git
```

Clone this repository into your home directory:
```bash
cd ~
git clone https://github.com/Oujiii/vps-setup.git
```

Run the setup script
```bash
cd vps-setup
bash first.sh (if on Debian or Ubuntu minimal)
bash ufw-fix.sh (if on Debian 10)
bash setup.sh
bash docker.sh (if a docker install is wanted)
```

# Setup prompts
When the setup script is run, you will be prompted to enter the username and password of the new user account. 

Following that, you will then be prompted to add a public ssh key (which should be from your local machine) for the new account. To generate an ssh key from your local machine:
```bash
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```

After that, you will be prompted for your [Tailscale Pre-authentication key](https://tailscale.com/kb/1085/auth-keys)

Finally, you will be prompted to specify a [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the server. It will be set to 'America/Sao_Paulo' if you do not specify a value.

# Supported versions
This setup script has been tested against Ubuntu 14.04, Ubuntu 16.04, Ubuntu 18.04, Ubuntu 20.04, Debian 9 (Stretch) and Debian 10 (Buster).

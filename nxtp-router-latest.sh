#For latest version router
#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 
echo -e '\e[40m\e[92m'
echo -e ' ============================================================== '
echo -e ' ====================@@@@@@@@@@@@@@@@@@%======================= '
echo -e ' ====================##################@======================= '
echo -e ' =================%#######################===================== '
echo -e ' ===============############################@================== '
echo -e ' ============@#################################================ '
echo -e ' ============@#################################================ '
echo -e ' ============@#################################================ '
echo -e ' ============@#################################================ '
echo -e ' ============@############@==##################================ '
echo -e ' ============@##%+++++++++*::+++++++++++++++%@@===++=========== '
echo -e ' ============@##:...........................*====+**=========== '
echo -e ' ============@####@....-///////*..========..*====+**=========== '
echo -e ' ============@#######*.-///////*..========..*====+**=========== '
echo -e ' ============@#######*..///////-..========..*====+**=========== '
echo -e ' ============@#######+--------------------**+====+**=========== '
echo -e ' ============@#####=======================##@====+**=========== '
echo -e ' ===============###============@#####=====##@====+**=========== '
echo -e ' ===============###=======================##@================== '
echo -e ' ===============###==================-----###-------=========== '
echo -e ' ===============###=================%###############%========== '
echo -e ' ===============###==========#######@::::::::::::*==###======== '
echo -e ' ===============###=================%###############%========== '
echo -e ' ===============###==================%%###%%%%%%%%%%=========== '
echo -e ' ===============###========%%%%%%%%%%%%@##===================== '
echo -e ' ===============###=======@############@======================= '
echo -e ' ===============###=======@##================================== '
echo -e ' ===============###=======@##================================== '
echo -e '\e[0m'
sleep 1
mkdir -p $HOME/connext
if [ ! $Private_Key ]; then
read -p "Insert your Private_Key from Metamask: " Private_Key
echo 'export Private_Key='\"${Private_Key}\" >> $HOME/connext/your.key
fi

sleep 2
if [ ! $Project_ID ]; then
read -p "Insert your Project ID from Infura: " Project_ID
echo 'export Project_ID='\"${Project_ID}\" >> $HOME/connext/infura.key
fi

#update and install packages
apt update && apt install git sudo unzip wget -y

#install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#install docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#install nxtp-route
cd $HOME/connext
git clone https://github.com/connext/nxtp-router-docker-compose.git
sleep 2 
cd $HOME/connext/nxtp-router-docker-compose
sleep 2 
git checkout amarok
sleep 2 
curl -fsSLI -o /dev/null -w %{url_effective} https://github.com/connext/nxtp/releases/latest | awk 'BEGIN{FS="v"} {print $2}' > router.version
sleep 2 
docker pull ghcr.io/connext/router:$(cat $HOME/connext/nxtp-router-docker-compose/router.version)

#create .env, config and key files
cp .env.example .env
sleep 2
wget -O config.json https://raw.githubusercontent.com/martynovalek/NXTP-Router-install/main/config.json
sleep 2
wget -O key.yaml https://raw.githubusercontent.com/martynovalek/NXTP-Router-install/main/key.yaml
sleep 2
#delete example files
rm config.example.json .env.example key.example.yaml
sleep 2

#Paste project ID to config.json
sed -i 's/224d26fcdc02495c921bb5d74702002e/'$Project_ID'/g' $HOME/connext/nxtp-router-docker-compose/config.json
sleep 2

#Paste private key to key.yaml
sed -i 's/your_privatekey/'$Private_Key'/g' key.yaml
sleep 2

#Paste router version to .env file
sed -i 's/latest/'$(cat $HOME/connext/nxtp-router-docker-compose/router.version)'/g' .env
sleep 2

docker-compose down
sleep 2
docker compose up -d
echo -e "\e[32mYour Router v.$(cat $HOME/connext/nxtp-router-docker-compose/router.version) \e[32mseems be running.\e[39m"
echo -e "Check logs using command: docker logs --follow --tail 100 router"

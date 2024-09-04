#!/bin/bash

function auswahl {
	echo "Was soll installiert werden?"
	echo "[1] Java Swapper fuer Minecraft"
	echo "[2] Counter-Strike Server"
	echo "[3] Garry's Mod Server"
	echo "[4] Ark Server"
	echo "[5] SteamCMD install"
	echo "[6] New Setup"
	read -p "Was soll gemacht werden: " auswahl 
}

function install_basic {
	sudo apt update
	sudo install btop tmux curl
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LANGUAGE=en_US.UTF-8
	sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
	service ssh restart
}

function install_ark {
	cd /home/Steam
	./steamcmd.sh +force_install_dir /home/Ark +login anonymous +app_update 376030 validate +quit
}

function install_garrysmod {
	cd /home/Steam
	./steamcmd.sh +force_install_dir /home/GarrysMod +login anonymous +app_update 4020 validate +quit
}

function install_counterstrike {
	cd /home/Steam
	./steamcmd.sh +force_install_dir /home/CounterStrike +login anonymous +app_updata 740 validate +quit
}

function install_steamcmd {
	mkdir /home/Steam
	cd /home/Steam
	sudo apt-get install lib32gcc-s1
	sudo apt-get install lib32stdc++6
	curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
	./steamcmd.sh
}

function install_minecraft {
	mkdir /home/Minecraft
	cd /home/Minecraft
	cat << EOL > Java_Swapper.sh
#!/bin/bash

# Verfügbare Java-Versionen und ihre Installationspakete
declare -A java_versions
java_versions=(
  ["8"]="openjdk-8-jdk"
  ["11"]="openjdk-11-jdk"
  ["17"]="openjdk-17-jdk"
  ["21"]="openjdk-21-jdk"
)

# Pfade der installierten Java-Versionen
declare -A java_paths
java_paths=(
  ["8"]="/usr/lib/jvm/java-8-openjdk-amd64"
  ["11"]="/usr/lib/jvm/java-11-openjdk-amd64"
  ["17"]="/usr/lib/jvm/java-17-openjdk-amd64"
  ["21"]="/usr/lib/jvm/java-21-openjdk-amd64"
)

# Funktion zur Installation der Java-Version
install_java() {
  local version=$1
  local package=${java_versions[$version]}
  echo "Installiere Java $version..."
  sudo apt-get update
  sudo apt-get install -y $package
}

# Aktuelle Java-Version anzeigen
echo "Aktuelle Java-Version:"
java -version 2>&1 | head -n 1

# Abfrage der gewünschten Java-Version
echo "Bitte wähle die gewünschte Java-Version:"
echo "1) Java 8"
echo "2) Java 11"
echo "3) Java 17"
echo "4) Java 21"
read -p "Eingabe (1/2/3/4): " version_choice

case $version_choice in
  1)
    selected_version="8"
    ;;
  2)
    selected_version="11"
    ;;
  3)
    selected_version="17"
    ;;
  4)
    selected_version="21"
    ;;
  *)
    echo "Ungültige Auswahl. Abbruch."
    exit 1
    ;;
esac

# Prüfen, ob die gewählte Version installiert ist
if [ -d "${java_paths[$selected_version]}" ]; then
  echo "Java $selected_version ist bereits installiert."
else
  echo "Java $selected_version ist nicht installiert. Installation wird gestartet."
  install_java $selected_version
fi

# Wechsel zur gewählten Java-Version
echo "Wechsle zu Java $selected_version..."
export JAVA_HOME="${java_paths[$selected_version]}"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Java-Version wurde gewechselt zu:"
java -version 2>&1 | head -n 1
EOL
	chmod +x Java_Swapper.sh
	echo "Fertig"
}

auswahl

case $auswahl in
        1)
                install_minecraft
                ;;
        2)
                install_counterstrike
                ;;
        3)
                install_garrysmod
                ;;
        4)
                install_ark
                ;;
        5)
                install_steamcmd
                ;;
        6)
                install_basic
                ;;
        *)
                echo "Ungueltige eingabe"
                exit 1
                ;;
esac

#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

for i in "${CMD[@]}"; do
    SYS="$i" && [[ -n $SYS ]] && break
done

for ((int = 0; int < ${#REGEX[@]}; int++)); do
    if [[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]]; then
        SYSTEM="${RELEASE[int]}" && [[ -n $SYSTEM ]] && break
    fi
done

archAffix(){
    case "$(uname -m)" in
        x86_64 | amd64 ) echo 'amd64' ;;
        armv8 | arm64 | aarch64 ) echo 'arm64' ;;
        * ) red "Unsupported CPU architecture!" && exit 1 ;;
    esac
}

endpointyx(){
    # Download endpoint optimization tool, thanks to an anonymous internet friend for sharing this tool
    wget https://gitlab.com/Misaka-blog/warp-script/-/raw/main/files/warp-yxip/warp-darwin-$(archAffix) -O warp
    
    # Start WARP endpoint IP optimization tool
    chmod +x warp && ./warp >/dev/null 2>&1
    
    # Show top 10 optimized endpoint IPs and how to use them
    green "The top 10 endpoint IPs are:"
    cat result.csv | awk -F, '$3!="timeout ms" {print} ' | sort -t, -nk2 -nk3 | uniq | head -11 | awk -F, '{print "Endpoint "$1" Packet Loss "$2" Average Latency "$3}'
    echo ""
    yellow "You can replace the default WireGuard Endpoint IP: engage.cloudflareclient.com:2408 with the locally optimized Endpoint IP"
   
    # Delete the WARP endpoint IP optimization tool and its related files
    rm -f warp ip.txt result.csv
}

endpoint4(){
    # Generate a list of optimized WARP IPv4 endpoint IP segments
    n=0
    iplist=100
    while true; do
        temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
    done
    while true; do
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
    done
	
	# Put the generated IP range list into ip.txt for program optimization
echo ${temp[@]} | sed -e 's/ /n/g' | sort -u > ip.txt

# Start optimization program
endpointyx
}

endpoint6(){
    # Generate optimized WARP IPv6 Endpoint IP range list
    n=0
    iplist=100
    while true; do
        temp[$n]=$(echo [2606:4700:d0::$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2)))])
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo [2606:4700:d1::$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2)))])
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
    done
    while true; do
        if [ $(echo ${temp[@]} | sed -e 's/ /n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo [2606:4700:d0::$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2)))])
            n=$(($n + 1))
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo [2606:4700:d1::$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%xn' $(($RANDOM * 2 + $RANDOM % 2)))])
            n=$(($n + 1))
        fi
    done

    # Put the generated IP range list into ip.txt for program optimization
    echo ${temp[@]} | sed -e 's/ /n/g' | sort -u > ip.txt

    # Start optimization program
    endpointyx
}

menu(){
    clear
    echo "######################################################################################"
    echo -e "#        ${RED}WARP Endpoint IP One-Click Optimization Script for Mac${PLAIN}        #"
    echo -e "# ${GREEN}Author${PLAIN}: MisakaNo's Little Breaking Station                         #"
    echo -e "# ${GREEN}Translator${PLAIN}: YeBeKhe - https://twitter.com/yebekhe                  #"
    echo -e "# ${GREEN}Blog${PLAIN}: https://blog.misaka.rest                                     #"
    echo -e "# ${GREEN}GitHub Project${PLAIN}: https://github.com/Misaka-blog                     #"
    echo -e "# ${GREEN}GitLab Project${PLAIN}: https://gitlab.com/Misaka-blog                     #"
    echo -e "# ${GREEN}Telegram Channel${PLAIN}: https://t.me/misakanocchannel                    #"
    echo -e "# ${GREEN}Telegram Group${PLAIN}: https://t.me/misakanoc                             #"
    echo -e "# ${GREEN}YouTube Channel${PLAIN}: https://www.youtube.com/@misaka-blog              #"
    echo "######################################################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} WARP IPv4 Endpoint IP Optimization ${YELLOW}(Default)${PLAIN}"
    echo -e " ${GREEN}2.${PLAIN} WARP IPv6 Endpoint IP Optimization"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} Exit Script"
    echo ""
    read -rp "Please enter an option [0-2]: " menuInput
    case $menuInput in
        2 ) endpoint6 ;;
        0 ) exit 1 ;;
        * ) endpoint4 ;;
    esac
}

menu

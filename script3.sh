#! /bin/bash
q="$(cat /etc/os-release | grep -Eo "ID_LIKE=.*")"
if [[ $q == ID_LIKE=debian ]]; then

    sed -i "/ethernets:/, $ d" /etc/netplan/*.yaml
    a="$(ip route | grep default | grep -Eo "en.*\s\p" | sed "s/.$//" | sed "s/.$//")"
    read -r -p "enter ip address " ip
    read -r -p "enter prefix " prefix
    read -r -p "enter ip gateway4 " gateway
    read -r -p "enter ip DNS: " dns
    read -r -p "enter ip DNS2: " dns2
    echo "   ethernets:" >> /etc/netplan/*.yaml
    echo "      $a:" >> /etc/netplan/*.yaml
    echo "         dhcp4: no" >> /etc/netplan/*.yaml

        if [[ $ip =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]]; then

            if [[ $prefix>0 && $prefix<=32 ]]; then
            echo "         addresses: [$ip/$prefix]" >> /etc/netplan/*.yaml
            else
            echo "Invalid IP Mask"
            exit 1
            fi
        else
        echo "Invalid IP address"
        exit 1
        fi

        if [[ $gateway =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]];  then

         echo "         gateway4: $gateway " >> /etc/netplan/*.yaml
         else
         echo "Invalid IP address"
         exit 1
        fi
         echo "         nameservers:" >> /etc/netplan/*.yaml

        if [[ $dns =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]];  then

        echo " Complid DNS $dns "
        else
        echo "Invalid DNS"
        exit 1
        fi

        if [[ $dns2 =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]];  then
        
        echo " Complid DNS $dns2 "
        else
        echo "Invalid DNS2"
        exit 1
        fi

        if [[ $dns == "" && $dns2 == "" ]]; then
         echo "            addresses: [8.8.8.8,8.8.4.4]" >> /etc/netplan/*.yaml
        else
         echo "            addresses: [$dns,$dns2]" >> /etc/netplan/*.yaml
        fi
            echo "   version: 2" >> /etc/netplan/*.yaml
sudo netplan apply

elif [[ $q == "ID_LIKE=\"rhel fedora"\" ]]; then

                if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "BOOTPROTO=\dhcp"; then
                echo "We have bootproto =dhcp"
                sed -i "s/BOOTPROTO=.*/BOOTPROTO=static/g" /etc/sysconfig/network-scripts/ifcfg-en*
                fi

                if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "ONBOOT=\no"; then
                echo "We have ondoot =no"
                sed -i "s/ONBOOT=no/ONBOOT=yes/g" /etc/sysconfig/network-scripts/ifcfg-en*
                fi


                read -r -p "Enter ip address " ip
                if [[ $ip =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]]; then

                    if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "IPADDR=.*"; then
                    echo "We have IPADDR="
                    sed -i "s/IPADDR=.*/IPADDR=$ip/g" /etc/sysconfig/network-scripts/ifcfg-en*
                    else
                    echo "IPADDR=$ip" >> /etc/sysconfig/network-scripts/ifcfg-en*
                    fi
                else
                    echo "Invalid IP address"
                    exit 1
                fi

                read -r -p "Enter default 255.255.255.0 NETMASK address " netmask
                if [[ $netmask =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]]; then

                if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "NETMASK=.*"; then
                echo "We have NETMASK "
                sed -i "s/NETMASK=.*/NETMASK=$netmask/g" /etc/sysconfig/network-scripts/ifcfg-en*
                else 
                    echo "NETMASK=$netmask" >> /etc/sysconfig/network-scripts/ifcfg-en*
                fi
                else
                    sed -i "s/NETMASK=.*/NETMASK=255.255.255.0/g"  /etc/sysconfig/network-scripts/ifcfg-en*
                fi
                

                read -r -p "Enter GATEWAY= address " gateway

                if [[ $gateway =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]]; then

                    if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "GATEWAY=.*"; then
                    echo "We have GATEWAY=$gateway"
                    sed -i "s/GATEWAY=.*/GATEWAY=$gateway/g" /etc/sysconfig/network-scripts/ifcfg-en*
                    else
                    echo "GATEWAY=$gateway" >> /etc/sysconfig/network-scripts/ifcfg-en*
                    fi
                else
                echo "Invalid IP address"
                exit 1
                fi

        read -r -p "Enter default 8.8.8.8 DNS1= address " dns1
        if [[ $dns1 =~ ^[1-9]+\.[0-9]+\.[0-9]+\.[1-9]+$ ]]; then
           if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "DNS1=.*"; then
            echo "We have DNS1=$dns1"
            sed -i "s/DNS1=.*/DNS1=$dns1/g" /etc/sysconfig/network-scripts/ifcfg-en*
            else
            echo "DNS1=$dns1" >> /etc/sysconfig/network-scripts/ifcfg-en*
            fi

        else
        sed -i "s/DNS1=.*/DNS1=8.8.8.8/g" /etc/sysconfig/network-scripts/ifcfg-en*
        fi

read -r -p "Enter default 8.8.4.4 DNS2= address " dns2
if [[ $dns2 =~ ^[1-9]+\.[0-9]+\.[0-9]+\.[1-9]+$ ]]; then
    if cat /etc/sysconfig/network-scripts/ifcfg-en* | grep "DNS2=.*"; then
        echo "We have DNS2=$dns2"
        sed -i "s/DNS2=.*/DNS2=$dns2/g" /etc/sysconfig/network-scripts/ifcfg-en*
    else
        echo "DNS2=$dns2" >> /etc/sysconfig/network-scripts/ifcfg-en*
    fi
else
    sed -i "s/DNS2=.*/DNS2=8.8.4.4/g"  /etc/sysconfig/network-scripts/ifcfg-en*
fi
    systemctl restart network
fi
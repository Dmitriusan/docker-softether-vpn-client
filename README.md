# Docker image for SoftEther VPN client
This will deploy a fully functional SoftEther VPN client as a docker image.

I've also included script with few hacks to make it to use dns and pull ip configuration and routes from the DHCP server.

Script stores it's configuration at ~/.docker-softether-vpn-client/conf/vpn_client.config . 
Either provide valid client configuration file vpn_client.config on this location, or start an interactive shell

    # export CONFIG_FILE=~/.docker-softether-vpn-client/conf/vpn_client.config
    # sudo docker build -t docker-softether-vpn-client_img .
    # sudo docker run --device=/dev/net/tun --cap-add=NET_ADMIN --net=host \
              -v ${CONFIG_FILE}:/usr/local/vpnclient/vpn_client.config -it --rm docker-softether-vpn-client_img /bin/bash

and perform setup steps as described here https://creudevel.wordpress.com/2014/02/10/install-softether-client-in-centos/comment-page-1/

By default, image expects VPN interface name to be vpn0. It's customizable via VPN_INTERFACE_NAME env variable in Dockerfile. 
SoftEther VPN client takes this name from its config file.  

Should be started as root or runs docker via sudo

    # ./service.sh start




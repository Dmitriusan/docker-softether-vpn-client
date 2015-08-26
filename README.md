# Docker image for SoftEther VPN client
This will deploy a fully functional SoftEther VPN client as a docker image.

I've also included script with few hacks to make it to use dns and pull ip configuration and routes from the DHCP server.

Script stores it's configuration at ~/.docker-softether-vpn-client/conf/vpn_client.config . 
Either provide valid client configuration file vpn_client.config on this location, or start an interactive shell

    # ./service.sh start ; ./service.sh stop
    # sudo docker -it docker-softether-vpn-client_img /bin/bash

and perform setup steps as described here https://creudevel.wordpress.com/2014/02/10/install-softether-client-in-centos/comment-page-1/

Should be started as root or runs docker via sudo

    # ./service.sh start




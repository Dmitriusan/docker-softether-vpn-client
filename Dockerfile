FROM ubuntu:trusty
MAINTAINER dmitriusan

# Origins:
# https://github.com/kawaz/ansible-role-softether-client/blob/master/tasks/main.yml

env DEBIAN_FRONTEND noninteractive

ENV VERSION v4.20-9608-rtm-2016.04.17

WORKDIR /usr/local/vpnclient

RUN apt-get update &&\
        apt-get -y -q install gcc make wget && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
        wget http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Client/64bit_-_Intel_x64_or_AMD64/softether-vpnclient-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-vpnclient.tar.gz &&\
        tar -xzvf /tmp/softether-vpnclient.tar.gz -C /usr/local/ &&\
        rm /tmp/softether-vpnclient.tar.gz &&\
        make i_read_and_agree_the_license_agreement &&\
        apt-get purge -y -q --auto-remove gcc make wget && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/dhcp/dhclient-enter-hooks.d/resolvconf ; \
        rm -f /etc/dhcp/dhclient-exit-hooks.d/resolvconf

CMD /usr/local/vpnclient/vpnclient start 2>&1 && \
        sed -ri 's/RUN="no"/RUN="yes"/g' /etc/dhcp/dhclient-exit-hooks.d/debug ; \
        sed -ri 's/#send host-name "andare.fugue.com";/also request rfc3442-classless-static-routes;/g' /etc/dhcp/dhclient.conf ; \
        echo 'sleep 3' >> /etc/dhcp/dhclient-exit-hooks.d/debug ; \
        echo 'source /etc/dhcp/dhclient-exit-hooks.d/rfc3442-classless-routes' >> /etc/dhcp/dhclient-exit-hooks.d/debug ; \
        chmod a+x '/etc/dhcp/dhclient-exit-hooks.d/rfc3442-classless-routes' ; \
# Interface is not up immediately
        sleep 5 && \
        dhclient -d vpn_irr

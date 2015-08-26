#!/usr/bin/env bash

export BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

NAME=$(basename ${BASEDIR})
IMGNAME=${NAME}_img
DATADIR=~/.${NAME}
CONFDIR=${DATADIR}/conf
CONFIG_FILE=${CONFDIR}/vpn_client.config
LOGDIR=${DATADIR}/log
# Get first DNS server for the current host
PRIMARY_DNS=$(cat /etc/resolv.conf |grep -i nameserver|head -n1|cut -d ' ' -f2)


case $1 in

  start )
    set -e

    mkdir -p ${CONFDIR}/
    touch ${CONFIG_FILE}

    mkdir -p ${LOGDIR}/
    chmod a+rw -R ${LOGDIR}

    # Build basic image.
    docker build -t ${IMGNAME} --pull=true ${BASEDIR}

    # Run the service itself
    sudo -c "/usr/bin/docker run --restart=always --device=/dev/net/tun --cap-add=NET_ADMIN --net=host \
              -v ${CONFIG_FILE}:/usr/local/vpnclient/vpn_client.config \
              --name ${NAME} -d ${IMGNAME}"

    bash -x ${BASH_SOURCE[0]} init-firewall

    set +e
  ;;

  stop )
    sudo dmi-su -c "docker stop ${NAME}"
    sudo dmi-su -c "docker rm ${NAME}"
  ;;

  restart )
    bash -x ${BASH_SOURCE[0]} stop
    bash -x ${BASH_SOURCE[0]} start
  ;;

  init-firewall )
  ;;

  reset-firewall )
  ;;

esac

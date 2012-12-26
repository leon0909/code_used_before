#!/bin/bash
# Start or stop Mysql -Replication SSH Tunnels
#
# Leonid Hedit <leonid.heidt@gmx.net>
# based on ssh abilities to make tunnels, and use preset keys for
# the ssh connections

### BEGIN INIT INFO
# Provides:          ssh toonels for MySQL Master Master / Master Slave data replication
# Required-Start:    $local_fs $remote_fs $syslog $named $network $time
# Required-Stop:     $local_fs $remote_fs $syslog $named $network
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start and stop the ssh toonels for MySQL data replication
# Description:       replication_tunnels is a script that creates ssh toonels for Master Slave Mysql Replication
### END INIT INFO

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/admin

SSH=$(which ssh)
# .........................................................................
# Please set all the needed Configuration inside this file
# in the /etc/default directory: /etc/default/mysql_replication
# .... here we include the configuration with the point inclusion ..........
#
[ -f "/etc/default/mysql_replication" ] && . /etc/default/mysql_replication.cfg || exit

case $1 in
  stop|Stop|STOP)
      [ -n "${MASTER_TOONEL_PID}" ] && kill -9 ${MASTER_TOONEL_PID}
      [ -n "${SLAVE_TOONEL_PID}" ] && kill -9 ${SLAVE_TOONEL_PID}
      sleep 1
      #THE_REST=$( ps -u ${SSH_KEY_USER} | grep \? | awk '{print $1}' | sort -r )
      #echo ${THE_REST}
      #[ "${THE_REST}" = "root" ] || kill -9 ${THE_REST}
      ;;
  start|Start|START)
      # [ -z "${STATUS_OUT}" ] && ${SSH} -f w-data@62.241.61.17 -L 37777:62.241.61.17:23306 -N &
      # [ -z "${STATUS_OUT}" ] && ${SSH} -f w-data@62.241.61.17 -L 37777:127.0.0.1:23306 -N &
      # sleep 2

      echo STATUS_MY_SLAVE:$STATUS_MY_SLAVE
      if [ -z "${STATUS_MY_SLAVE}" ] ; then
         echo "Creating ssh-tunnel to the MYSQL Replication SLAVE of this Server so that "
         echo "this server could be a MASTER for the target server"
         #debug: 
         echo "${SSH} -a -i ${RSA_FILE} -T -R ${SLAVE_PORT}:127.0.0.1:${SLAVE_MYSQL_PORT} ${SSH_KEY_USER}@${MY_SLAVE} -N &"
         ${SSH} -a -i ${RSA_FILE} -T -R ${SLAVE_PORT}:127.0.0.1:${SLAVE_MYSQL_PORT} ${SSH_KEY_USER}@${MY_SLAVE} -N &
      else
        echo "SLAVE SSH Toonel is already running under the PID:"${SLAVE_TOONEL_PID}
        fi
      ;;
   *)
      echo $0 "< start | stop >"
  esac

### TUNNEL THROUGH FIREWALL '''
# tunnle for ssh login from outside open:
# *** # ssh -R 50122:localhost:22 w-data@www.$YOUR_FQDN
# and as user w-data on the www.$YOUR_FQDN with:
# *** #  ssh -p 50122 user@localhost 
# => where localhost will be then this maschine
#''' TUNNEL THROUGH FIREWALL '''

exit


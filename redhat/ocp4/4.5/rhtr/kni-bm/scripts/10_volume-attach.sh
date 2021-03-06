#!/bin/bash
OSP_PROJECT="nw979-project"
GUID="nw979"

attach() {
  for NODE in $( openstack --os-cloud=$OSP_PROJECT server list|grep worker|cut -d\| -f3|sed 's/ //g' )
  do
          openstack --os-cloud=$OSP_PROJECT server add volume $NODE $NODE-volume
  done
}

detach() {
  for NODE in $( openstack --os-cloud=$OSP_PROJECT server list|grep worker|cut -d\| -f3|sed 's/ //g' )
  do
          openstack --os-cloud=$OSP_PROJECT server remove volume $NODE $NODE-volume
  done
}

poweroff() {
  /usr/bin/ipmitool -I lanplus -H10.20.0.3 -p6200 -Uadmin -Predhat chassis power off
  /usr/bin/ipmitool -I lanplus -H10.20.0.3 -p6201 -Uadmin -Predhat chassis power off
  /usr/bin/ipmitool -I lanplus -H10.20.0.3 -p6202 -Uadmin -Predhat chassis power off
  /usr/bin/ipmitool -I lanplus -H10.20.0.3 -p6203 -Uadmin -Predhat chassis power off
  /usr/bin/ipmitool -I lanplus -H10.20.0.3 -p6204 -Uadmin -Predhat chassis power off
  /usr/bin/ipmitool -I lanplus -H10.20.0.3 -p6205 -Uadmin -Predhat chassis power off
}

case $1 in
  attach) attach ;;
  detach) poweroff
          sleep 10
          detach ;;
  power) poweroff ;;
  *) attach ;;
esac

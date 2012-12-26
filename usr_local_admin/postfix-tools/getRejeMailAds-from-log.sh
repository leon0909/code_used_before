#!/bin/bash
#
# /usr/local/admin/postfix-tools/getRejeMailAds.sh
#
# receives parameters that look like this:
# par1 = '550'
# par2 = '5.1.6'
# par3 = /var/log/mail.log
#

if [ -z "${3}" ]; then
  echo "false argument count in calling $0"
  echo "please call as follows:"
  echo "$0 <rejectionCode(like:550 5.1.6)> <rejectionTxt(only for the output)> </pathToThe/mail.log | mail.log.1 > "
  exit
  fi

  REJ_CODE1=$1
  REJ_CODE2=$2
  MAILLOG=$3
  # debug: echo "grep -n ${REJ_CODE} ${MAILLOG} | awk '-Fto=<' '{print "\$2"}' | awk '-F>' '{print "\$1"}' | grep -v $YOUR_FQDN"

  for i in $(grep -n "${REJ_CODE1} ${REJ_CODE2}" ${MAILLOG} | awk '-Fto=<' '{print $2}' | awk '-F>' '{print $1}' | grep -v $YOUR_FQDN )
      do
      [ -n "$( echo ${i} | grep -v smtp.$YOUR_FQDN )" ] && echo $( echo ${i} | grep -v smtp.$YOUR_FQDN )
      done

  exit 1                      

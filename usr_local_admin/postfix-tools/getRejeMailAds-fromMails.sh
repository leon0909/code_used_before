#!/bin/bash

ACCOUNT=$1
EXPRESSION1=$2
EXPRESSION2=$3
DEBUG=$4

ACC_PATH=/home/vmail/$YOUR_FQDN/${ACCOUNT}
PERL_CODE=/tmp/some_code
TEMP_FILE=/tmp/tmp_file

cat <<'EOF'> ${PERL_CODE}
        my ($vor,$email,) = $_ =~ /^.*<(\w+:)?((\w+(\W*\w+)*)?@(\w+(\W*\w+)*)?\.(...?))>/i ;
        chomp($email);
        next if ($email =~ /office/i);
        next if ($email =~ /olga.zv/i);
        next if ($email =~ /Grillner/i);
        next if ($email =~ /Poulain/i);
        next if ($email =~ /Morich/i);
        next if ($email =~ /Butzek/i);
        next if ($email =~ /Schools/i);
        next if ($email =~ /Gibson/i);
        next if ($email =~ /daemon/i);
        next if ($email =~ /smtp.$YOUR_FQDN/i);
        next if ($email =~ /postmaster/i);
        next if ($email =~ /mailto/i);
        next if ($email =~ /href/i);
        print $email."\n";
EOF

> ${TEMP_FILE}

grep -R "${EXPRESSION1} ${EXPRESSION2}" ${ACC_PATH}/ | awk "-F:" '{print $1":"$2}' | while read THISMAIL; do
        cat $THISMAIL | perl -ln ${PERL_CODE} >> ${TEMP_FILE} 
        done
cat  ${TEMP_FILE} | sort | uniq        
[ "${DEBUG}" = "" ] || rm -f ${PERL_CODE} && rm -f ${TEMP_FILE}

#        perl -lne 'my ($email,)=$_=~ /<((\w*\..\w*)?@(\w*).\.(...?))>/g ; next if ($email eq ""); next if ($email =~ /office/g); next if ($email !~ /(.*)@(.*)\.(...?)/);print $email."\n";' | \
# my ($vor,$email,) = $_ =~ /^.*<(\w+:)?((\w*\.*\w*)?@(\w+(\W*\w+)*)?\.(...?))>/i ;
# my ($vor,$email,) = $_ =~ /^.*<(\w+:)?((\w*\.*\w*)?@(\w+(\W*\w+)*)?\.(...?))>/i ;

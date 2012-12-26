#!/bin/bash  
#  
# (c) GPLv3   
  # Search for a known (sub-)string in a file (i.e.: Begrüßung),  
  # by testing all available encodings.  
  #  
# For example, you make a fast look into the file, and see "Begr??ung", and from the context you reconstruct, it has to
# be Begrüßung (you will have very differnet examples in you language, I guess) then you start the tool by 
# encoding_finder.sh foofile.txt Begrüßung  
#

   [[ $# -ne 2 ]] && echo "Usage: encoding-finder.sh FILE PATTERN_WITH_UMLAUT_FOR_SURE_IN_FILE" && exit  
   FILE=$1  
   PATTERN=$2  
   LIST=$( iconv -l | sed 's/..$//')
   #echo $LIST
   for enc in $LIST ; do   
     NOERR=$(iconv -f UTF-8 -t $enc $FILE  2>/dev/null | grep $PATTERN) &&  echo $enc   
     done   

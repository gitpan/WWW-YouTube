#!/bin/sh
##

MOZILLA_BIN='/usr/bin/firefox'

cd `dirname $0`

while true
do
   if [ -f /var/www/youtube/tag/tag.ctl ]
   then
      CMD="`cat /var/www/youtube/tag/tag.ctl`"

      echo "tag: $CMD"

      ./tag.plx $CMD --yt_mozilla_bin=$MOZILLA_BIN

      rm -f /var/www/youtube/tag/tag.ctl

   fi

   if [ -f /var/www/youtube/tag/result.ctl ]
   then
      RLT="openurl(`cat /var/www/youtube/tag/result.ctl`,new-tab)"

      echo "result: $RLT"

      ( $MOZILLA_BIN -remote $RLT 2>&1 ) > /dev/null &

      sleep 5

      rm -f /var/www/youtube/tag/result.ctl

   fi

   for x in tag_*
   do
      if [ -f "/var/www/youtube/tag/${x}.please_delete_me" ]
      then

      echo "deleting: $x"

      rm -Rf $x

      rm -f "/var/www/youtube/tag/${x}.please_delete_me"

      fi

   done

   rm -f /var/www/youtube/tag/tag_*.please_delete_me

   sleep 5

done


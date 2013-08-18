#!/bin/sh
# Credit goes to TH3CR@CK3R for making this script at http://top-hat-sec.com/forum/index.php?topic=3127.0

echo ""
echo "BEEF USES PORT 3000 AS DEFAULT"
echo "PLEASE SELECT AN OPTION TO CONTINUE"
echo ""
echo "1 = USE DEFAULT [3000]"
echo "2 = SELECT A DIFFERENT PORT"
echo ""
echo "OPTION NUMBER: \c"
read option


if [ $option = "1" ]; then

echo "STARTING BEEF SERVER"
xterm -e sudo beef-server &
exit

else
if [ $option = "2" ]; then

  sleep 1
  echo ""
  echo "WHAT PORT WOULD YOU LIKE TO USE? \c"
  read port
  sleep 1
  echo ""
  echo "STARTING BEEF SERVER"
  xterm -e sudo beef-server -p $port &
  exit

fi
fi

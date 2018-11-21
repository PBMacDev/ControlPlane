#!/bin/bash

#curl http://standards-oui.ieee.org/oui/oui.txt | grep "..-..-.." | grep hex | sed "s/(hex)//" | awk -F '\t' '{print $1,$3}' | awk -F '       ' '{print $1"\t"$3}' | sed -e 's/^[ \t]*//' > ../Resources/oui.txt 

cat ./oui20181116.txt | grep "..-..-.." | grep hex | sed "s/(hex)//" | awk -F '\t' '{print $1,$3}' | awk -F '       ' '{print $1"\t"$3}' | sed -e 's/^[ \t]*//' > ../Resources/oui.txt 
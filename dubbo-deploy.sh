#!/bin/bash

DUBBO_PATH="/ROOT/www/dubbo/"

#################################
# Useage
#################################

if [[ -z $1 || -z $2 || -z $3 ]]
then
	echo "Useage:./dubbo-deploy.sh \"service-name\" \"port\" \"service.tar.gz\"";
	exit 1;
fi
#################################


SERVICE_PATH="$1_$2";
echo "$SERVICE_PATH";

#################################
# check directory
#################################

if [[ ! -d "/ROOT/www/dubbo/$SERVICE_PATH" ]]
then
	#su - webmaster -c "mkdir -p /ROOT/www/dubbo/""$SERVICE_PATH";
	mkdir -p "$DUBBO_PATH""$SERVICE_PATH";
	ls -al "$DUBBO_PATH";
fi
#################################

TAR_TYPE=`echo "$3" | awk -F "." '{print $NF}'`;
echo $TAR_TYPE

if [[ "$TAR_TYPE" == "gz" ]]
then
	echo "start tar gz"
	tar -zxf "$3" -C "$DUBBO_PATH""$SERVICE_PATH";
else
	echo "start tar"
	tar -xf "$3" -C "$DUBBO_PATH""$SERVICE_PATH";
fi

#################################
# change config file
#################################

if [[ -e "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties ]]
then
	echo "dubbo.properties is here";
	PORT_CONF='';
	PORT_CONF=`egrep -c '^dubbo.protocol.port' "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties`;
	if [[ "$PORT_CONF" == 0 ]]         #PORT_CONF没有找到port设置。
	then
		echo "1"
		echo "$PORT_CONF";
		sed -i '$a\dubbo.protocol.port='"${2}" "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
	else					#如果有一个或多个port的设置，则替换为参数指定的端口号。
		echo "2"
		echo "$PORT_CONF";
		echo "$2";
		sed -i "s/^dubbo\.protocol\.port=.*/dubbo.protocol.port="$2"/" "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
	fi
else
	echo "there is no dubbo.properties";
fi











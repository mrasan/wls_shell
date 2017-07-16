#!/bin/bash
if [ $# = "0" ]; then
	echo "useage:"
	echo "wls_log_clean.sh domain_path limit_day"
	echo "domain_path:/u01/app/Oracle/Middleware/user_projects/domains/portal_domain"
	echo "limit_day:2(default 5)(day)"
	exit 0
fi
wls_domain=$1
limit_day=$2
wls_server="${wls_domain}/servers"
if [ ! -d ${wls_server} ];then
	echo "path not fount:${wls_server}"
	exit 1
fi
if [ "${limit_day}" = "" ]; then
	limit_day=5
fi
for x in `find ${wls_server} -maxdepth 1 -type d`
do
	if [ "${wls_server}" = "${x}" ];then
		continue
	fi
	echo $x
	log_path="${x}/logs/"
	server_name=`basename ${x}`
	echo $server_name
	for y in `find ${log_path} -maxdepth 1 -mtime ${limit_day}  -type f`
	do
		file_name=`basename ${y}`
		if [ "${file_name}" = "${server_name}.out" ];then
			echo "skip file:${y}"
			continue
		fi
		if [ "${file_name}" = "${server_name}.log" ];then
			echo "skip file:${y}"
			continue
		fi
		if [ "${file_name}" = "access.log" ];then
			echo "skip file:${y}"
			continue
		fi
		echo "delete file:${y}"
		rm -rf ${y}
	done
done



output=$(./main.sh $1)
registrar=$(echo "$output" | grep -v '#' | grep "registrar:")
owner=$(echo "$output" | grep -v '#' | grep "owner:" )
ns1=$(echo "$output" | grep -v '#' | grep "ns1:" )
ns2=$(echo "$output" | grep -v '#' | grep "ns2:" )
ns3=$(echo "$output" | grep -v '#' | grep "ns3:" )
ns4=$(echo "$output" | grep -v '#' | grep "ns4:" )
mailserver=$(echo "$output" | grep -v '#' | grep "mailserver:" )
analytics=$(echo "$output" | grep "analytics:")

results=""




if [[ "${@#-info}" = "$@" ]]
then
	:
else
	recommended_usage="$0 $1"
	echo "$output" | grep "#registrar"
	rcount=$(echo "$registrar" |  wc -l)
	echo -e "\tCount: $rcount, filter out with -fr"
	if [ "$rcount" -ge 100 ]; then
		recommended_usage+=" -fr"
	fi



	echo "$output" | grep "#owner"
	ocount=$(echo "$owner" |  wc -l)
	echo -e "\tCount: $ocount, filter out with -fo"
	if [ "$ocount" -ge 100 ]; then
		recommended_usage+=" -fo"
	fi

	echo "$output" | grep "#ns1"
	ns1count=$(echo "$ns1" |  wc -l)
	echo -e "\tCount: $ns1count, filter out with -fns1"
	if [ "$ns1count" -ge 100 ]; then
		recommended_usage+=" -fns1"
	fi

	echo "$output" | grep "#ns2"
	ns2count=$(echo "$ns2" |  wc -l)
	echo -e "\tCount: $ns2count, filter out with -fns2"
	if [ "$ns2count" -ge 100 ]; then
		recommended_usage+=" -fns2"
	fi

	echo "$output" | grep "#ns3"
	ns3count=$(echo "$ns3" |  wc -l)
	echo -e "\tCount: $ns3count, filter out with -fns3"
	if [ "$ns3count" -ge 100 ]; then
		recommended_usage+=" -fns3"
	fi


	echo "$output" | grep "#ns4"
	ns4count=$(echo "$ns4" |  wc -l)
	echo -e "\tCount: $ns4count, filter out with -fns4"
	if [ "$ns4count" -ge 100 ]; then
		recommended_usage+=" -fns4"
	fi

	echo "$output" | grep '#mailserver'
	mxcount=$(echo "$mailserver" |  wc -l)
	echo -e "\tCount: $mxcount, filter out with -fmx"
	if [ "$mxcount" -ge 100 ]; then
		recommended_usage+=" -fmx"
	fi


	for id in $(echo "$analytics" | cut -d ' ' -f 2 | sort -u);
	do
		echo "Found Analytics ID: $id"
		acount=$(echo "$output" | grep "$id" |  wc -l)
		echo -e "\tCount: $acount, filter out with -fa=$id"
		if [ "$acount" -ge 100 ]; then
			recommended_usage+=" -fa=$id"
		fi
	done


	echo -e "\n\nTo show only resulting domains, add -unique parameter"
	echo -e "\n\nTo show list sorted by domains, use -bydomain parameter"
	echo -e "Recommended usage: $recommended_usage"
	exit
fi


if [[ "${@#-fo}" = "$@" ]]
then
	results+=$'\n'
	results+="${owner}"
fi

if [[ "${@#-fr}" = "$@" ]]
then
		results+=$'\n'
    results+="${registrar}"
fi

if [[ "${@#-fns1}" = "$@" ]]
then
		results+=$'\n'
    results+="${ns1}"
fi

if [[ "${@#-fns2}" = "$@" ]]
then
		results+=$'\n'
    results+="${ns2}"
fi

if [[ "${@#-fns3}" = "$@" ]]
then
		results+=$'\n'
    results+="${ns3}"
fi

if [[ "${@#-fns4}" = "$@" ]]
then
		results+=$'\n'
    results+="${ns4}"
fi

if [[ "${@#-fmx}" = "$@" ]]
then
		results+=$'\n'
    results+="${mailserver}"
fi

for id in $(echo "$analytics" | cut -d ' ' -f 2 | sort -u);
do
	if [[ "${@#-fa=$id}" = "$@" ]]
	then
		results+=$'\n'
    results+="$(echo "$output" | grep "$id")"
	fi
done


if [[ "${@#-unique}" = "$@" ]]
then
	:
else
    echo "$results" | cut -d ' ' -f 1 | cut -d ':' -f 2 | sort -u
    exit
fi

if [[ "${@#-bydomain}" = "$@" ]]
then
	:
else
    domainlist=$(echo "$results" | grep -v '^$' | cut -d ' ' -f 1 | cut -d ':' -f 2 | sort -u)
    echo "$domainlist" | while read domain ;
    do
    	echo "$domain: $(echo "$results" | grep ":$domain" | cut -d ':' -f 1 | tr $'\n' ',' | sed 's/,$//g')";
    done;
    exit
fi



echo "$results"
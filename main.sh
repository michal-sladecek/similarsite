if [ ! -f ./domains.txt ]; then
    wget https://sk-nic.sk/subory/domains.txt
fi

domain_entry=$(grep  "^$1" ./domains.txt)

(for i in $(grep -Pa "^(www\.)?$1" ./ids.txt | grep --only-matching -P '(UA-\d*-)'; grep -a "^$1" ./ids.txt | grep --only-matching -P '(ca-pub-\d*)';); 
	do grep -a "$i" ./ids.txt ; done;) | sort -u  | sed 's/^/analytics:/g'



for mailserver in $(grep "^$1" ./mx_zaznamy.txt | cut -d ' ' -f 2);
do
	echo "#mailserver:$mailserver"
	grep "$mailserver\$"  ./mx_zaznamy.txt | cut -d ' '  -f 1 | sed 's/^/mailserver:/g' | sed 's/\.$//g'
done

echo "#registrar:$(echo $domain_entry | cut -d ';' -f 2)" 
grep "$(echo $domain_entry | cut -d ';' -f 2)" ./domains.txt | cut -d ';' -f 1 | sed 's/^/registrar:/g'
echo "#owner:$(echo $domain_entry | cut -d ';' -f 3)" 
grep "$(echo $domain_entry | cut -d ';' -f 3)" ./domains.txt | cut -d ';' -f 1 | sed 's/^/owner:/g'


echo "#ns1:$(echo $domain_entry | cut -d ';' -f 5)"
grep "$(echo $domain_entry | cut -d ';' -f 5)" ./domains.txt | cut -d ';' -f 1 | sed 's/^/ns1:/g'
echo "#ns2:$(echo $domain_entry | cut -d ';' -f 6)"
grep "$(echo $domain_entry | cut -d ';' -f 6)" ./domains.txt | cut -d ';' -f 1 | sed 's/^/ns2:/g'
echo "#ns3:$(echo $domain_entry | cut -d ';' -f 7)"
grep "$(echo $domain_entry | cut -d ';' -f 7)" ./domains.txt | cut -d ';' -f 1 | sed 's/^/ns3:/g'
echo "#ns4:$(echo $domain_entry | cut -d ';' -f 8)"
grep "$(echo $domain_entry | cut -d ';' -f 8)" ./domains.txt | cut -d ';' -f 1 | sed 's/^/ns4:/g'



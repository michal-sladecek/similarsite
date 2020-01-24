(for i in $(grep -Pa "^(www\.)?$1" ./ids.txt | grep --only-matching -P '(UA-\d*-)'; grep -a "^$1" ./ids.txt | grep --only-matching -P '(ca-pub-\d*)';); do grep -a "$i" ./ids.txt ; done;) | sort -u 


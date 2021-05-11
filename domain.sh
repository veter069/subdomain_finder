#!/bin/bash
curl -s "https://rapiddns.io/subdomain/$1?full=1#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sed 's/#results//g' | sort -u | tee -a output.txt
curl -s "https://dns.bufferover.run/dns?q=.$1" |jq -r .FDNS_A[]|cut -d',' -f2|sort -u | tee -a output.txt
curl -s "https://riddler.io/search/exportcsv?q=pld:$1" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a output.txt
curl -s "https://www.virustotal.com/ui/domains/$1/subdomains?limit=40" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a output.txt
curl -s "https://certspotter.com/api/v0/certs?domain=$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a output.txt
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u | tee -a output.txt
curl -s "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a output.txt
curl -s "https://securitytrails.com/list/apex_domain/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep ".$1" | sort -u | tee -a output.txt
curl -s "https://crt.sh/?q=$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee -a output.txt
for url in $(cat output.txt); do host $url; done | grep "has address" | cut -d " " -f 1,4 | sort -u

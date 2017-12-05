grep server_name /etc/nginx/sites-enabled/* -RiI

SITESLOCATION="$HOME/sites.html"
rm -f "$SITESLOCATION"

# Now generate sites.html.
grep server_name /etc/nginx/sites-enabled/* -RiI | sed 's/.*name //' | \
awk 'length($0)>3' | cut -f1 -d";" | cut -f1 -d" " | \
awk '{print "<li><a href=\"https://"$1"\">"$1"</a></li>"}' >> $SITESLOCATION

echo "The enabled sites have been outputted in html list format at $SITESLOCATION"
echo "Edit and then move this file to wherever the code is for dport.me"
echo "Note: Not all domains are included (https://stackoverflow.com/a/46230868/3846032)"

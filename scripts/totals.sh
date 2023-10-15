TQ=$(find /var/www/franklin/said -name "*.txt" -print | wc -l)
TBQ=$(numfmt --to=si --format %.2f $TQ)
DQ=$(find /var/www/franklin/said -name "*.txt" -mtime -1 -print | wc -l)
echo "<p>There have been <i> $DQ </i> queries in the last 24 hours, and <i> $TBQ </i> queries to Franklin since initiation on this server. Updates every 10 minutes.</p>"

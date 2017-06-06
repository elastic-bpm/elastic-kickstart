#/bin/bash

echo "Arguments: $1 $2 $3"

# Wait for swarm1 to be up
command="ssh -q $1 exit"
eval $command
ret=$?
while [ $ret -gt "0" ]
do
  sleep 10
  echo Retry
  eval $command
  ret=$?
done
echo Executing script

# Start up elastic
ssh $1 'bash -s' < ./start_elastic.sh

# Wait for nodes to be ready
ssh $1 'bash -s' < ./wait_for_nodes.sh

echo "Sleeping a bit"
ssh $1 'sleep 30'

# Start test
start=$(date '+%Y-%m-%d %H:%M')
ssh $1 'cat > /tmp/params.json' < $2
ssh $1 'bash -s' < ./start_test.sh
end=$(date '+%Y-%m-%d %H:%M')

echo "Test started at $start and finished at $end"

# Time to download the stuff!
node ../results/app.js "$start" "$end" "$1" /mnt/c/Users/Johannes/Projects/elastic/results/output/
out=$(date -d"$start" +%Y%m%d%H%M)
echo "Downloaded to output: $out"

# Generate .bat file
cat << EOF > /mnt/c/Users/Johannes/Projects/elastic/results/output/convert.$out$1.bat
Rscript --vanilla ..\rcode\graph.r C:/Users/Johannes/Projects/elastic/results/output/$out.$1
EOF


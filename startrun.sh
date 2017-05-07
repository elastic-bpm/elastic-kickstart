#/bin/bash

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



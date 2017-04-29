#/bin/bash

# Wait for swarm1 to be up
command="ssh -q swarm1-master exit"
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
ssh swarm1-master 'bash -s' < ./start_elastic.sh

# Wait for nodes to be ready
ssh swarm1-master 'bash -s' < ./wait_for_nodes.sh



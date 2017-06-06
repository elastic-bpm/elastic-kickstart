#!/bin/bash
echo Waiting for API to be ready
until $(curl --output /dev/null --silent --head --fail localhost:8080/api/running); do
    printf '.'
    sleep 5
done

echo Sleeping 5 minutes for machines to settle down
sleep 60
echo 1
sleep 60
echo 2
sleep 60
echo 3
sleep 60
echo 4
sleep 60
echo DONE!

echo Sending run command
curl -H "Content-Type: application/json" -X POST -d @/tmp/params.json localhost:8080/api/runTest

echo Waiting for test to finish
until $(curl --output /dev/null --silent --head --fail localhost:8080/api/testDone); do
    printf '.'
    sleep 5
done

echo Test is done, deleting workers

curl -X DELETE localhost:8080/api/docker/services/workers

echo Done


## Orgs Numbers
1 : MUL Mundra
2 : AEML Mumbai
3 : JVVNL Jaipur
4 : APRL KAWAI
5 : APML Tiroda
6 : APML MUNDRA
7: GETCO 
8: MSECTL
9: RRVPNL
10: PGCIL
11: Gujarat SLDc
12: Maharastra SLDC
13: Rajasthan SLDC
14: West RLDC
15: North RLDC

## Start the network

./network.sh up -ca -s couchdb

## Stop the network

./network.sh down

## Create ChannelOne
./network.sh createChannel -c channelone -pp ChannelOne

<<<<<<< Updated upstream

## Deploy Chaincode


./network.sh deployCC -c channelone -ccn chaincode1 -ccl javascript -ccp ../chaincode -cci InitLedger


 -ccep "OR('MULMUNDRAMSP.peer','APRLKAWAIMSP.peer')"
=======
## Deploy Chaincode
 ./network.sh deployCC -c channelone -ccn chaincode -ccl javascript -ccp ../chaincode -cci InitLedger
>>>>>>> Stashed changes

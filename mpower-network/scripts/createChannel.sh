#!/bin/bash

# imports  
. scripts/envVar.sh
. scripts/utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
PROFILE="$5"
: ${CHANNEL_NAME:="mychannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
: ${PROFILE:="ChannelOne"}

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelGenesisBlock() {
	which configtxgen
	if [ "$?" -ne 0 ]; then
		fatalln "configtxgen tool not found."
	fi
	set -x
	configtxgen -profile $PROFILE -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	setGlobals 1
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		osnadmin channel join --channel-id $CHANNEL_NAME --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >&log.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  FABRIC_CFG_PATH=$PWD/../config/
  ORG=$1
  setGlobals $ORG
	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer0.org${ORG} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
  ORG=$1
  docker exec cli ./scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME 
}

FABRIC_CFG_PATH=${PWD}/configtx

## Create channel genesis block
infoln "Generating channel genesis block '${CHANNEL_NAME}.block'"
createChannelGenesisBlock

FABRIC_CFG_PATH=$PWD/../config/
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

## Join First channel
if [ "$PROFILE" = "ChannelOne" ]; then
	## Join all the peers to the channel
	infoln "Joining MULMUNDRA peer to the channel..."
	joinChannel 1
	infoln "Joining APRL Kawai peer to the channel..."
	joinChannel 4
	infoln "Joining RRVPNL peer to the channel..."
	joinChannel 9
	infoln "Joining Rajasthan SLDC peer to the channel..."
	joinChannel 13
	infoln "Joining PGCIL peer to the channel..."
	joinChannel 10
	infoln "Joining West RLDC peer to the channel..."
	joinChannel 14
	infoln "Joining Gujarat SLDC peer to the channel..."
	joinChannel 11
	infoln "Joining GETCO peer to the channel..."
	joinChannel 7

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for MULMUNDRA..."
	setAnchorPeer 1
	infoln "Setting anchor peer for APRL Kawai..."
	setAnchorPeer 4
	infoln "Setting anchor peer for RRVPNL..."
	setAnchorPeer 9
	infoln "Setting anchor peer for Rajasthan SLDC..."
	setAnchorPeer 13
	infoln "Setting anchor peer for PGCIL..."
	setAnchorPeer 10
	infoln "Setting anchor peer for West RLDC..."
	setAnchorPeer 14
	infoln "Setting anchor peer for Gujarat SLDC..."
	setAnchorPeer 11
	infoln "Setting anchor peer for GETCO..."
	setAnchorPeer 7

## Join Second channel
elif [ "$PROFILE" = "ChannelTwo"  ]; then
	## Join all the peers to the channel
	infoln "Joining MULMUNDRA peer to the channel..."
	joinChannel 1
	infoln "Joining APML Tiroda peer to the channel..."
	joinChannel 5
	infoln "Joining MSECTL peer to the channel..."
	joinChannel 8
	infoln "Joining Maharastra SLDC peer to the channel..."
	joinChannel 12
	infoln "Joining PGCIL peer to the channel..."
	joinChannel 10
	infoln "Joining West RLDC peer to the channel..."
	joinChannel 14
	infoln "Joining Gujarat SLDC peer to the channel..."
	joinChannel 11
	infoln "Joining GETCO peer to the channel..."
	joinChannel 7

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for MULMUNDRA..."
	setAnchorPeer 1
	infoln "Setting anchor peer for APML Tiroda..."
	setAnchorPeer 5
	infoln "Setting anchor peer for MSECTL..."
	setAnchorPeer 8
	infoln "Setting anchor peer for Maharastra SLDC..."
	setAnchorPeer 12
	infoln "Setting anchor peer for PGCIL..."
	setAnchorPeer 10
	infoln "Setting anchor peer for West RLDC..."
	setAnchorPeer 14
	infoln "Setting anchor peer for Gujarat SLDC..."
	setAnchorPeer 11
	infoln "Setting anchor peer for GETCO..."
	setAnchorPeer 7

## Join Third channel
elif [ "$PROFILE" = "ChannelThree"  ]; then
	## Join all the peers to the channel
	infoln "Joining MUL MUNDRA peer to the channel..."
	joinChannel 1
	infoln "Joining APML Mundra peer to the channel..."
	joinChannel 6
	infoln "Joining Gujarat SLDC peer to the channel..."
	joinChannel 11
	infoln "Joining GETCO peer to the channel..."
	joinChannel 7

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for MUL MUNDRA..."
	setAnchorPeer 1
	infoln "Setting anchor peer forAPML Mundra..."
	setAnchorPeer 6
	infoln "Setting anchor peer for Gujarat SLDC..."
	setAnchorPeer 11
	infoln "Setting anchor peer for GETCO..."
	setAnchorPeer 7

## Join Fourth channel
elif [ "$PROFILE" = "ChannelFour"  ]; then
	## Join all the peers to the channel
	infoln "Joining APRL Kawai to the channel..."
	joinChannel 4
	infoln "Joining RRVPNL peer to the channel..."
	joinChannel 9
	infoln "Joining Rajasthan SLDC peer to the channel..."
	joinChannel 13
	infoln "Joining Maharastra SLDC peer to the channel..."
	joinChannel 12
	infoln "Joining PGCIL peer to the channel..."
	joinChannel 10
	infoln "Joining West RLDC peer to the channel..."
	joinChannel 14
	infoln "Joining North RLDC peer to the channel..."
	joinChannel 15
	infoln "Joining MSECTL peer to the channel..."
	joinChannel 8
	infoln "Joining AEML Mumbai peer to the channel..."
	joinChannel 2

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for APRL Kawai..."
	setAnchorPeer 4
	infoln "Setting anchor peer for RRVPNL..."
	setAnchorPeer 9
	infoln "Setting anchor peer for Rajasthan SLDC..."
	setAnchorPeer 13
	infoln "Setting anchor peer for Maharastra SLDC..."
	setAnchorPeer 12
	infoln "Setting anchor peer for PGCIL..."
	setAnchorPeer 10
	infoln "Setting anchor peer for West RLDC..."
	setAnchorPeer 14
	infoln "Setting anchor peer for North RLDC..."
	setAnchorPeer 15
	infoln "Setting anchor peer for AEML Mumbai..."
	setAnchorPeer 2
	infoln "Setting anchor peer for MSECTL..."
	setAnchorPeer 8


## Join Fifth channel
elif [ "$PROFILE" = "ChannelFive"  ]; then
	## Join all the peers to the channel
	infoln "Joining APML Tiroda peer to the channel..."
	joinChannel 5
	infoln "Joining Maharastra SLDC peer to the channel..."
	joinChannel 12
	infoln "Joining MSECTL peer to the channel..."
	joinChannel 8
	infoln "Joining AEML Mumbai peer to the channel..."
	joinChannel 2

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for APML Tiroda..."
	setAnchorPeer 5
	infoln "Setting anchor peer for Maharastra SLDC"
	setAnchorPeer 12
	infoln "Setting anchor peer for MSECTL peer"
	setAnchorPeer 8
	infoln "Setting anchor peer for AEML Mumbai."
	setAnchorPeer 2

elif [ "$PROFILE" = "ChannelSix"]; then 
	## Join all peers to the channel
	infoln "Joining APML Mundra peer to the channel..."
	joinChannel 6
	infoln "Joining PGCIL peer to the channel..."
	joinChannel 10
	infoln "Joining West RLDC peer to the channel..."
	joinChannel 14
	infoln "Joining Maharastra SLDC peer to the channel..."
	joinChannel 12
	infoln "Joining MSECTL peer to the channel..."
	joinChannel 8
	infoln "Joining AEML Mumbai peer to the channel..."
	joinChannel 2

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for APML Mundra..."
	setAnchorPeer 5
	infoln "Setting anchor peer for PGCIL peer to the channel"
	setAnchorPeer 10
	infoln "Setting anchor peer for West RLDC peer to the channel"
	setAnchorPeer 14
	infoln "Setting anchor peer for Maharastra SLDC"
	setAnchorPeer 12
	infoln "Setting anchor peer for MSECTL peer"
	setAnchorPeer 8
	infoln "Setting anchor peer for AEML Mumbai."
	setAnchorPeer 2

elif [ "$PROFILE" = "ChannelSeven"]; then
	infoln "Joining APRL Kawai peer to the channel..."
	joinChannel 4
	infoln "Joining RRVPNL peer to the channel..."
	joinChannel 9
	infoln "Joining Rajasthan SLDC peer to the channel..."
	joinChannel 13
	infoln "Joining JVVNL Jaipur peer to the channel..."
	joinChannel 3


	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for APRL Kawai..."
	setAnchorPeer 4
	infoln "Setting anchor peer for RRVPNL..."
	setAnchorPeer 9
	infoln "Setting anchor peer for Rajasthan SLDC..."
	setAnchorPeer 13
	infoln "Setting anchor peer for JVVNL Jaipur..."
	setAnchorPeer 3

## Join Fifth channel
elif [ "$PROFILE" = "ChannelEight"  ]; then
	## Join all the peers to the channel
	infoln "Joining APML Tiroda peer to the channel..."
	joinChannel 5
	infoln "Joining Maharastra SLDC peer to the channel..."
	joinChannel 12
	infoln "Joining MSECTL peer to the channel..."
	joinChannel 8
	infoln "Joining PGCIL peer to the channel..."
	joinChannel 10
	infoln "Joining West RLDC peer to the channel..."
	joinChannel 14
	infoln "Joining North RLDC peer to the channel..."
	joinChannel 15
	infoln "Joining Rajasthan SLDC peer to the channel..."
	joinChannel 13
	infoln "Joining RRVPNL peer to the channel..."
	joinChannel 9
	infoln "Joining JVVNL Jaipur peer to the channel..."
	joinChannel 3

	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for APML Tiroda..."
	setAnchorPeer 5
	infoln "Setting anchor peer for Maharastra SLDC"
	setAnchorPeer 12
	infoln "Setting anchor peer for MSECTL peer"
	setAnchorPeer 8
	infoln "Setting anchor peer for PGCIL"
	setAnchorPeer 10
	infoln "Setting anchor peer for  West RLDC"
	setAnchorPeer 14
	infoln "Setting anchor peer for North RLDC"
	setAnchorPeer 15
	infoln "Setting anchor peer for Rajasthan SLDC"
	setAnchorPeer 13
	infoln "Setting anchor peer for JVVNL Jaipur"
	setAnchorPeer 3
	infoln "Setting anchor peer for RRVPNL"
	setAnchorPeer 9

elif [ "$PROFILE" = "ChannelEight"  ]; then
	## Join all the peers to the channel
	infoln "Joining APML Mundra peer to the channel..."
	joinChannel 6
	infoln "Joining PGCIL peer to the channel..."
	joinChannel 10
	infoln "Joining West RLDC peer to the channel..."
	joinChannel 14
	infoln "Joining North RLDC peer to the channel..."
	joinChannel 15
	infoln "Joining Rajasthan SLDC peer to the channel..."
	joinChannel 13
	infoln "Joining RRVPNL peer to the channel..."
	joinChannel 9
	infoln "Joining JVVNL Jaipur peer to the channel..."
	joinChannel 3

## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for APML Mundra..."
	setAnchorPeer 6
	infoln "Setting anchor peer for PGCIL"
	setAnchorPeer 10
	infoln "Setting anchor peer for  West RLDC"
	setAnchorPeer 14
	infoln "Setting anchor peer for North RLDC"
	setAnchorPeer 15
	infoln "Setting anchor peer for Rajasthan SLDC"
	setAnchorPeer 13
	infoln "Setting anchor peer for JVVNL Jaipur"
	setAnchorPeer 3
	infoln "Setting anchor peer for RRVPNL"
	setAnchorPeer 9
else
    errorln "Org${PROFILE} unknown"
fi

successln "Channel '$CHANNEL_NAME' joined"

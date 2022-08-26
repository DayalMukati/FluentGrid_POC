#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# import utils
. scripts/envVar.sh
. scripts/configUpdate.sh


# NOTE: this must be run in a CLI container since it requires jq and configtxlator 
createAnchorPeerUpdate() {
  infoln "Fetching channel config for channel $CHANNEL_NAME"
  fetchChannelConfig $ORG $CHANNEL_NAME ${CORE_PEER_LOCALMSPID}config.json

  infoln "Generating anchor peer update transaction for Org${ORG} on channel $CHANNEL_NAME"

  if [ $ORG -eq 1 ]; then
    HOST="peer0.mulmundra.mpower.in"
    PORT=7051
  elif [ $ORG -eq 2 ]; then
    HOST="peer0.aemlmumbai.mpower.in"
    PORT=9051
  elif [ $ORG -eq 3 ]; then
    HOST="peer0.jvvnljaipur.mpower.in"
    PORT=10051
  elif [ $ORG -eq 4 ]; then
    HOST="peer0.aprlkawai.mpower.in"
    PORT=11051
  elif [ $ORG -eq 5 ]; then
    HOST="peer0.apmltiroda.mpower.in"
    PORT=12051
  elif [ $ORG -eq 6 ]; then
    HOST="peer0.apmlmundra.mpower.in"
    PORT=13051
  elif [ $ORG -eq 7 ]; then
    HOST="peer0.getco.mpower.in"
    PORT=14051
  elif [ $ORG -eq 8 ]; then
    HOST="peer0.msetcl.mpower.in"
    PORT=17051
  elif [ $ORG -eq 9 ]; then
    HOST="peer0.rrvpnl.mpower.in"
    PORT=15051
  elif [ $ORG -eq 10 ]; then
    HOST="peer0.pgcil.mpower.in"
    PORT=16051
  elif [ $ORG -eq 11 ]; then
    HOST="peer0.gujaratsldc.mpower.in"
    PORT=18051
  elif [ $ORG -eq 12 ]; then
    HOST="peer0.maharastrasldc.mpower.in"
    PORT=19051
  elif [ $ORG -eq 13 ]; then
    HOST="peer0.rajasthansldc.mpower.in"
    PORT=20051
  elif [ $ORG -eq 14 ]; then
    HOST="peer0.westernrldc.mpower.in"
    PORT=21051
  elif [ $ORG -eq 15 ]; then
    HOST="peer0.northernrldc.mpower.in"
    PORT=22051
  else
    errorln "Org${ORG} unknown"
  fi

  set -x
  # Modify the configuration to append the anchor peer 
  jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json
  { set +x; } 2>/dev/null

  # Compute a config update, based on the differences between 
  # {orgmsp}config.json and {orgmsp}modified_config.json, write
  # it as a transaction to {orgmsp}anchors.tx
  createConfigUpdate ${CHANNEL_NAME} ${CORE_PEER_LOCALMSPID}config.json ${CORE_PEER_LOCALMSPID}modified_config.json ${CORE_PEER_LOCALMSPID}anchors.tx
}

updateAnchorPeer() {
  peer channel update -o orderer.mpower.in:7050 --ordererTLSHostnameOverride orderer.mpower.in -c $CHANNEL_NAME -f ${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile "$ORDERER_CA" >&log.txt
  res=$?
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  successln "Anchor peer set for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME'"
}

ORG=$1
CHANNEL_NAME=$2
setGlobalsCLI $ORG

createAnchorPeerUpdate 

updateAnchorPeer 

#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/msp/tlscacerts/tlsca.mpower.in-cert.pem
export PEER0_MULMUNDRA_CA=${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/ca.crt
export PEER0_AEMLMUMBAI_CA=${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/ca.crt
export PEER0_JVVNL_CA=${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/ca.crt
export PEER0_APRLKAWAI_CA=${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/ca.crt
export PEER0_APMLTIRODA_CA=${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/ca.crt
export PEER0_APMLMUNDRA_CA=${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/ca.crt
export PEER0_GETCO_CA=${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/ca.crt
export PEER0_MSETCL_CA=${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/ca.crt
export PEER0_RRVPNL_CA=${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/ca.crt
export PEER0_PGCIL_CA=${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/ca.crt
export PEER0_GUJSLDC_CA=${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/ca.crt
export PEER0_MAHASLDC_CA=${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/ca.crt
export PEER0_RAJSLDC_CA=${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/ca.crt
export PEER0_WESTRLDC_CA=${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/ca.crt
export PEER0_NORTHRLDC_CA=${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/ca.crt

export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    infoln "Using organization MUL Mundra"
    export CORE_PEER_LOCALMSPID="MULMUNDRAMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MULMUNDRA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/users/Admin@mulmundra.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    infoln "Using organization AEML Mumbai"
    export CORE_PEER_LOCALMSPID="AEMLMUMBAIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_AEMLMUMBAI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/users/Admin@aemlmumbai.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG -eq 3 ]; then
    infoln "Using organization JVVNL Jaipur"
    export CORE_PEER_LOCALMSPID="JVVNLMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_JVVNL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/users/Admin@jvvnljaipur.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:10051
  elif [ $USING_ORG -eq 4 ]; then
    infoln "Using organization APRL Kawai"
    export CORE_PEER_LOCALMSPID="APRLKAWAIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_APRLKAWAI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/users/Admin@aprlkawai.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:11051
  elif [ $USING_ORG -eq 5 ]; then
    infoln "Using organization APML Tiroda"
    export CORE_PEER_LOCALMSPID="APMLTIRODAMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_APMLTIRODA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/Admin@apmltiroda.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:12051
  elif [ $USING_ORG -eq 6 ]; then
    infoln "Using organization APML Mundra"
    export CORE_PEER_LOCALMSPID="APMLMUNDRAMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_APMLMUNDRA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/users/Admin@apmlmundra.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:13051
  elif [ $USING_ORG -eq 7 ]; then
    infoln "Using organization GETCO"
    export CORE_PEER_LOCALMSPID="GETCOMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_GETCO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/getco.mpower.in/users/Admin@getco.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:14051
  elif [ $USING_ORG -eq 8 ]; then
    infoln "Using organization MSETCL"
    export CORE_PEER_LOCALMSPID="MSETCLMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MSETCL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/Admin@msetcl.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:17051
  elif [ $USING_ORG -eq 9 ]; then
    infoln "Using organization RRVPNL"
    export CORE_PEER_LOCALMSPID="RRVPNLMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RRVPNL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/Admin@rrvpnl.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:15051
  elif [ $USING_ORG -eq 10 ]; then
    infoln "Using organization PGCIL"
    export CORE_PEER_LOCALMSPID="PGCILMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PGCIL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/Admin@pgcil.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:16051
  elif [ $USING_ORG -eq 11 ]; then
    infoln "Using organization Gujarat SLDC"
    export CORE_PEER_LOCALMSPID="GUJSLDCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_GUJSLDC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/users/Admin@gujaratsldc.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:18051
  elif [ $USING_ORG -eq 12 ]; then
    infoln "Using organization Maharastra SLDC"
    export CORE_PEER_LOCALMSPID="MAHASLDCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MAHASLDC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/users/Admin@maharastrasldc.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:19051
  elif [ $USING_ORG -eq 13 ]; then
    infoln "Using organization Rajasthan SLDC"
    export CORE_PEER_LOCALMSPID="RAJSLDCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RAJSLDC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/users/Admin@rajasthansldc.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:20051
  elif [ $USING_ORG -eq 14 ]; then
    infoln "Using organization West RLDC"
    export CORE_PEER_LOCALMSPID="WESTRLDCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WESTRLDC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/users/Admin@westernrldc.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:21051
  elif [ $USING_ORG -eq 15 ]; then
    infoln "Using organization North RLDC"
    export CORE_PEER_LOCALMSPID="NORTHRLDCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_NORTHRLDC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/users/Admin@northernrldc.mpower.in/msp
    export CORE_PEER_ADDRESS=localhost:22051

  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.mulmundra.mpower.in:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.aemlmumbai.mpower.in:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.jvvnljaipur.mpower.in:10051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.aprlkawai.mpower.in:11051
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_ADDRESS=peer0.apmltiroda.mpower.in:12051
  elif [ $USING_ORG -eq 6 ]; then
    export CORE_PEER_ADDRESS=peer0.apmlmundra.mpower.in:13051
  elif [ $USING_ORG -eq 7 ]; then
    export CORE_PEER_ADDRESS=peer0.getco.mpower.in:14051
  elif [ $USING_ORG -eq 8 ]; then
    export CORE_PEER_ADDRESS=peer0.msetcl.mpower.in:17051
  elif [ $USING_ORG -eq 9 ]; then
    export CORE_PEER_ADDRESS=peer0.rrvpnl.mpower.in:15051
  elif [ $USING_ORG -eq 10 ]; then
    export CORE_PEER_ADDRESS=peer0.pgcil.mpower.in:16051
  elif [ $USING_ORG -eq 11 ]; then
    export CORE_PEER_ADDRESS=peer0.gujaratsldc.mpower.in:18051
  elif [ $USING_ORG -eq 12 ]; then
    export CORE_PEER_ADDRESS=peer0.maharastrasldc.mpower.in:19051
  elif [ $USING_ORG -eq 13 ]; then
    export CORE_PEER_ADDRESS=peer0.rajasthansldc.mpower.in:20051
  elif [ $USING_ORG -eq 14 ]; then
    export CORE_PEER_ADDRESS=peer0.westernrldc.mpower.in:21051
  elif [ $USING_ORG -eq 15 ]; then
    export CORE_PEER_ADDRESS=peer0.northernrldc.mpower.in:22051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_ORG$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}

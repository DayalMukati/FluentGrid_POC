#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=mulmundra
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/mulmundra.mpower.in/tlsca/tlsca.mulmundra.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/mulmundra.mpower.in/ca/ca.mulmundra.mpower.in-cert.pem
ORGMSP=MULMUNDRAMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/mulmundra.mpower.in/connection-mulmundra.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/mulmundra.mpower.in/connection-mulmundra.yaml

ORG=aemlmumbai
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/aemlmumbai.mpower.in/tlsca/tlsca.aemlmumbai.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/aemlmumbai.mpower.in/ca/ca.aemlmumbai.mpower.in-cert.pem
ORGMSP=AEMLMUMBAIMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/aemlmumbai.mpower.in/connection-aemlmumbai.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/aemlmumbai.mpower.in/connection-aemlmumbai.yaml

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

ORG=jvvnljaipur
P0PORT=10051
CAPORT=6054
PEERPEM=organizations/peerOrganizations/jvvnljaipur.mpower.in/tlsca/tlsca.jvvnljaipur.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/jvvnljaipur.mpower.in/ca/ca.jvvnljaipur.mpower.in-cert.pem
ORGMSP=JVVNLMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/jvvnljaipur.mpower.in/connection-jvvnljaipur.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/jvvnljaipur.mpower.in/connection-jvvnljaipur.yaml

ORG=getco
P0PORT=14051
CAPORT=13054
PEERPEM=organizations/peerOrganizations/getco.mpower.in/tlsca/tlsca.getco.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/getco.mpower.in/ca/ca.getco.mpower.in-cert.pem
ORGMSP=GETCOMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/getco.mpower.in/connection-getco.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/getco.mpower.in/connection-getco.yaml

ORG=aprlkawai
P0PORT=11051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/aprlkawai.mpower.in/tlsca/tlsca.aprlkawai.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/aprlkawai.mpower.in/ca/ca.aprlkawai.mpower.in-cert.pem
ORGMSP=APRLKAWAIMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/aprlkawai.mpower.in/connection-aprlkawai.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/aprlkawai.mpower.in/connection-aprlkawai.yaml

ORG=apmltiroda
P0PORT=12051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/apmltiroda.mpower.in/tlsca/tlsca.apmltiroda.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/apmltiroda.mpower.in/ca/ca.apmltiroda.mpower.in-cert.pem
ORGMSP=APMLTIRODAMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/apmltiroda.mpower.in/connection-apmltiroda.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/apmltiroda.mpower.in/connection-apmltiroda.yaml

ORG=apmlmundra
P0PORT=13051
CAPORT=12054
PEERPEM=organizations/peerOrganizations/apmlmundra.mpower.in/tlsca/tlsca.apmlmundra.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/apmlmundra.mpower.in/ca/ca.apmlmundra.mpower.in-cert.pem
ORGMSP=APMLMUNDRAMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/apmlmundra.mpower.in/connection-apmlmundra.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/apmlmundra.mpower.in/connection-apmlmundra.yaml

ORG=rrvpnl
P0PORT=15051
CAPORT=15054
PEERPEM=organizations/peerOrganizations/rrvpnl.mpower.in/tlsca/tlsca.rrvpnl.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/rrvpnl.mpower.in/ca/ca.rrvpnl.mpower.in-cert.pem
ORGMSP=RRVPNLMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/rrvpnl.mpower.in/connection-rrvpnl.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/rrvpnl.mpower.in/connection-rrvpnl.yaml


ORG=pgcil
P0PORT=16051
CAPORT=16054
PEERPEM=organizations/peerOrganizations/pgcil.mpower.in/tlsca/tlsca.pgcil.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/pgcil.mpower.in/ca/ca.pgcil.mpower.in-cert.pem
ORGMSP=PGCILMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/pgcil.mpower.in/connection-pgcil.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/pgcil.mpower.in/connection-pgcil.yaml

ORG=msetcl
P0PORT=17051
CAPORT=14054
PEERPEM=organizations/peerOrganizations/msetcl.mpower.in/tlsca/tlsca.msetcl.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/msetcl.mpower.in/ca/ca.msetcl.mpower.in-cert.pem
ORGMSP=MSETCLMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/msetcl.mpower.in/connection-msetcl.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/msetcl.mpower.in/connection-msetcl.yaml

ORG=gujaratsldc
P0PORT=18051
CAPORT=17054
PEERPEM=organizations/peerOrganizations/gujaratsldc.mpower.in/tlsca/tlsca.gujaratsldc.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/gujaratsldc.mpower.in/ca/ca.gujaratsldc.mpower.in-cert.pem
ORGMSP=GUJSLDCMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/gujaratsldc.mpower.in/connection-gujaratsldc.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/gujaratsldc.mpower.in/connection-gujaratsldc.yaml

ORG=maharastrasldc
P0PORT=19051
CAPORT=18054
PEERPEM=organizations/peerOrganizations/maharastrasldc.mpower.in/tlsca/tlsca.maharastrasldc.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/maharastrasldc.mpower.in/ca/ca.maharastrasldc.mpower.in-cert.pem
ORGMSP=MAHASLDCMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/maharastrasldc.mpower.in/connection-maharastrasldc.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/maharastrasldc.mpower.in/connection-maharastrasldc.yaml

ORG=rajasthansldc
P0PORT=20051
CAPORT=19054
PEERPEM=organizations/peerOrganizations/rajasthansldc.mpower.in/tlsca/tlsca.rajasthansldc.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/rajasthansldc.mpower.in/ca/ca.rajasthansldc.mpower.in-cert.pem
ORGMSP=RAJSLDCMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/rajasthansldc.mpower.in/connection-rajasthansldc.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/rajasthansldc.mpower.in/connection-rajasthansldc.yaml

ORG=westernrldc
P0PORT=21051
CAPORT=20054
PEERPEM=organizations/peerOrganizations/westernrldc.mpower.in/tlsca/tlsca.westernrldc.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/westernrldc.mpower.in/ca/ca.westernrldc.mpower.in-cert.pem
ORGMSP=WESTRLDCMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/westernrldc.mpower.in/connection-westernrldc.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/westernrldc.mpower.in/connection-westernrldc.yaml

ORG=northernrldc
P0PORT=22051
CAPORT=21054
PEERPEM=organizations/peerOrganizations/northernrldc.mpower.in/tlsca/tlsca.northernrldc.mpower.in-cert.pem
CAPEM=organizations/peerOrganizations/northernrldc.mpower.in/ca/ca.northernrldc.mpower.in-cert.pem
ORGMSP=NORTHRLDCMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/northernrldc.mpower.in/connection-northernrldc.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/northernrldc.mpower.in/connection-northernrldc.yaml

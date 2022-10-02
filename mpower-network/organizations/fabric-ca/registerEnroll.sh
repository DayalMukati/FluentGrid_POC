#!/bin/bash

function createMulmundra() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/mulmundra.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminmul:adminpw@localhost:7054 --caname ca-mulmundra --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mulmundra.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mulmundra.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mulmundra.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mulmundra.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-mulmundra --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-mulmundra --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-mulmundra --id.name mulmundraadmin --id.secret mulmundraadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-mulmundra -M "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/msp" --csr.hosts peer0.mulmundra.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-mulmundra -M "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.mulmundra.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/tlsca/tlsca.mulmundra.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/peers/peer0.mulmundra.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/ca/ca.mulmundra.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-mulmundra -M "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/users/User1@mulmundra.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/users/User1@mulmundra.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://mulmundraadmin:mulmundraadminpw@localhost:7054 --caname ca-mulmundra -M "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/users/Admin@mulmundra.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mulmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mulmundra.mpower.in/users/Admin@mulmundra.mpower.in/msp/config.yaml"
}

function createAemlmumbai() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/aemlmumbai.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminaeml:adminpw@localhost:8054 --caname ca-aemlmumbai --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aemlmumbai.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aemlmumbai.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aemlmumbai.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aemlmumbai.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-aemlmumbai --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-aemlmumbai --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-aemlmumbai --id.name aemlmumbaiadmin --id.secret aemlmumbaiadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-aemlmumbai -M "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/msp" --csr.hosts peer0.aemlmumbai.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-aemlmumbai -M "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.aemlmumbai.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/tlsca/tlsca.aemlmumbai.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/peers/peer0.aemlmumbai.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/ca/ca.aemlmumbai.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-aemlmumbai -M "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/users/User1@aemlmumbai.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/users/User1@aemlmumbai.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://aemlmumbaiadmin:aemlmumbaiadminpw@localhost:8054 --caname ca-aemlmumbai -M "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/users/Admin@aemlmumbai.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/aemlmumbai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aemlmumbai.mpower.in/users/Admin@aemlmumbai.mpower.in/msp/config.yaml"
}

function createGetco() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/getco.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/getco.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admingetco:adminpw@localhost:13054 --caname ca-getco --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-getco.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-getco.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-getco.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-getco.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-getco --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-getco --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-getco --id.name getcoadmin --id.secret getcoadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/msp" --csr.hosts peer0.getco.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.getco.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/getco.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/getco.mpower.in/tlsca/tlsca.getco.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/getco.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/getco.mpower.in/ca/ca.getco.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:13054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/User1@getco.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/User1@getco.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://getcoadmin:getcoadminpw@localhost:13054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/Admin@getco.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/Admin@getco.mpower.in/msp/config.yaml"
}

function createMsetcl() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/msetcl.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/msetcl.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminmsetcl:adminpw@localhost:14054 --caname ca-msetcl --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-msetcl.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-msetcl.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-msetcl.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-msetcl.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-msetcl --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-msetcl --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-msetcl --id.name msetcladmin --id.secret msetcladminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:14054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/msp" --csr.hosts peer0.msetcl.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:14054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.msetcl.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/tlsca/tlsca.msetcl.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/ca/ca.msetcl.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:14054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/User1@msetcl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/User1@msetcl.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://msetcladmin:msetcladminpw@localhost:14054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/Admin@msetcl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/Admin@msetcl.mpower.in/msp/config.yaml"
}

function createPgcil() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/pgcil.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/pgcil.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminpgcil:adminpw@localhost:16054 --caname ca-pgcil --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-pgcil.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-pgcil.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-pgcil.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-pgcil.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-pgcil --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-pgcil --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-pgcil --id.name pgciladmin --id.secret pgciladminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:16054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/msp" --csr.hosts peer0.pgcil.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:16054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.pgcil.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/tlsca/tlsca.pgcil.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/ca/ca.pgcil.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:16054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/User1@pgcil.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/User1@pgcil.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://pgciladmin:pgciladminpw@localhost:16054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/Admin@pgcil.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/Admin@pgcil.mpower.in/msp/config.yaml"
}

function createRrvpnl() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/rrvpnl.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminrrvpnl:adminpw@localhost:15054 --caname ca-rrvpnl --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-rrvpnl --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-rrvpnl --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-rrvpnl --id.name rrvpnladmin --id.secret rrvpnladminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/msp" --csr.hosts peer0.rrvpnl.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.rrvpnl.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/tlsca/tlsca.rrvpnl.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/ca/ca.rrvpnl.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:15054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/User1@rrvpnl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/User1@rrvpnl.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://rrvpnladmin:rrvpnladminpw@localhost:15054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/Admin@rrvpnl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/Admin@rrvpnl.mpower.in/msp/config.yaml"
}

function createJvvnlJaipur() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/jvvnljaipur.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminjvvnl:adminpw@localhost:6054 --caname ca-jvvnljaipur --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-jvvnljaipur.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-jvvnljaipur.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-jvvnljaipur.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-jvvnljaipur.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-jvvnljaipur --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-jvvnljaipur --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-jvvnljaipur --id.name jvvnljaipuradmin --id.secret jvvnljaipuradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-jvvnljaipur -M "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/msp" --csr.hosts peer0.jvvnljaipur.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-jvvnljaipur -M "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.jvvnljaipur.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/tlsca/tlsca.jvvnljaipur.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/peers/peer0.jvvnljaipur.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/ca/ca.jvvnljaipur.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-jvvnljaipur -M "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/users/User1@jvvnljaipur.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/users/User1@jvvnljaipur.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://jvvnljaipuradmin:jvvnljaipuradminpw@localhost:6054 --caname ca-jvvnljaipur -M "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/users/Admin@jvvnljaipur.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/jvvnljaipur/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/jvvnljaipur.mpower.in/users/Admin@jvvnljaipur.mpower.in/msp/config.yaml"
}

function createAprlKawai() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/aprlkawai.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminkawai:adminpw@localhost:10054 --caname ca-aprlkawai --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-aprlkawai.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-aprlkawai.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-aprlkawai.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-aprlkawai.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-aprlkawai --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-aprlkawai --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-aprlkawai --id.name aprlkawaiadmin --id.secret aprlkawaiadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-aprlkawai -M "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/msp" --csr.hosts peer0.aprlkawai.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-aprlkawai -M "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.aprlkawai.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/tlsca/tlsca.aprlkawai.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/peers/peer0.aprlkawai.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/ca/ca.aprlkawai.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-aprlkawai -M "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/users/User1@aprlkawai.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/users/User1@aprlkawai.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://aprlkawaiadmin:aprlkawaiadminpw@localhost:10054 --caname ca-aprlkawai -M "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/users/Admin@aprlkawai.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/aprlkawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aprlkawai.mpower.in/users/Admin@aprlkawai.mpower.in/msp/config.yaml"
}

function createApmlMundra() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/apmlmundra.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminapmlmun:adminpw@localhost:12054 --caname ca-apmlmundra --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-apmlmundra.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-apmlmundra.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-apmlmundra.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-apmlmundra.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-apmlmundra --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-apmlmundra --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-apmlmundra --id.name apmlmundraadmin --id.secret apmlmundraadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca-apmlmundra -M "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/msp" --csr.hosts peer0.apmlmundra.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca-apmlmundra -M "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.apmlmundra.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/tlsca/tlsca.apmlmundra.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/peers/peer0.apmlmundra.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/ca/ca.apmlmundra.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:12054 --caname ca-apmlmundra -M "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/users/User1@apmlmundra.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/users/User1@apmlmundra.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://apmlmundraadmin:apmlmundraadminpw@localhost:12054 --caname ca-apmlmundra -M "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/users/Admin@apmlmundra.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/apmlmundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmlmundra.mpower.in/users/Admin@apmlmundra.mpower.in/msp/config.yaml"
}

function createApmlTiroda() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/apmltiroda.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admintiroda:adminpw@localhost:11054 --caname ca-apmltiroda --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-apmltiroda --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-apmltiroda --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-apmltiroda --id.name apmltirodaadmin --id.secret apmltirodaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/msp" --csr.hosts peer0.apmltiroda.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.apmltiroda.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/tlsca/tlsca.apmltiroda.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/ca/ca.apmltiroda.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/User1@apmltiroda.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/User1@apmltiroda.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://apmltirodaadmin:apmltirodaadminpw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/Admin@apmltiroda.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/Admin@apmltiroda.mpower.in/msp/config.yaml"
}

# function createApmlTiroda() {
#   infoln "Enrolling the CA admin"
#   mkdir -p organizations/peerOrganizations/apmltiroda.mpower.in/

#   export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/

#   set -x
#   fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-apmltiroda --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   echo 'NodeOUs:
#   Enable: true
#   ClientOUIdentifier:
#     Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
#     OrganizationalUnitIdentifier: client
#   PeerOUIdentifier:
#     Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
#     OrganizationalUnitIdentifier: peer
#   AdminOUIdentifier:
#     Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
#     OrganizationalUnitIdentifier: admin
#   OrdererOUIdentifier:
#     Certificate: cacerts/localhost-11054-ca-apmltiroda.pem
#     OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml"

#   infoln "Registering peer0"
#   set -x
#   fabric-ca-client register --caname ca-apmltiroda --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   infoln "Registering user"
#   set -x
#   fabric-ca-client register --caname ca-apmltiroda --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   infoln "Registering the org admin"
#   set -x
#   fabric-ca-client register --caname ca-apmltiroda --id.name apmltirodaadmin --id.secret apmltirodaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   infoln "Generating the peer0 msp"
#   set -x
#   fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/msp" --csr.hosts peer0.apmltiroda.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/msp/config.yaml"

#   infoln "Generating the peer0-tls certificates"
#   set -x
#   fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.apmltiroda.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/ca.crt"
#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/server.crt"
#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/server.key"

#   mkdir -p "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/tlscacerts"
#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/tlscacerts/ca.crt"

#   mkdir -p "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/tlsca"
#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/tlsca/tlsca.apmltiroda.mpower.in-cert.pem"

#   mkdir -p "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/ca"
#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/peers/peer0.apmltiroda.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/ca/ca.apmltiroda.mpower.in-cert.pem"

#   infoln "Generating the user msp"
#   set -x
#   fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/User1@apmltiroda.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/User1@apmltiroda.mpower.in/msp/config.yaml"

#   infoln "Generating the org admin msp"
#   set -x
#   fabric-ca-client enroll -u https://apmltirodaadmin:apmltirodaadminpw@localhost:11054 --caname ca-apmltiroda -M "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/Admin@apmltiroda.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/apmltiroda/tls-cert.pem"
#   { set +x; } 2>/dev/null

#   cp "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/apmltiroda.mpower.in/users/Admin@apmltiroda.mpower.in/msp/config.yaml"
# }

function createGujaratSldc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/gujaratsldc.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admingujsldc:adminpw@localhost:17054 --caname ca-gujaratsldc --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-gujaratsldc.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-gujaratsldc.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-gujaratsldc.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-gujaratsldc.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-gujaratsldc --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-gujaratsldc --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-gujaratsldc --id.name gujaratsldcadmin --id.secret gujaratsldcadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:17054 --caname ca-gujaratsldc -M "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/msp" --csr.hosts peer0.gujaratsldc.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:17054 --caname ca-gujaratsldc -M "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.gujaratsldc.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/tlsca/tlsca.gujaratsldc.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/peers/peer0.gujaratsldc.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/ca/ca.gujaratsldc.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:17054 --caname ca-gujaratsldc -M "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/users/User1@gujaratsldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/users/User1@gujaratsldc.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gujaratsldcadmin:gujaratsldcadminpw@localhost:17054 --caname ca-gujaratsldc -M "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/users/Admin@gujaratsldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gujaratsldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gujaratsldc.mpower.in/users/Admin@gujaratsldc.mpower.in/msp/config.yaml"
}

function createMaharastraSldc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/maharastrasldc.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminmahasldc:adminpw@localhost:18054 --caname ca-maharastrasldc --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-maharastrasldc.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-maharastrasldc.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-maharastrasldc.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-maharastrasldc.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-maharastrasldc --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-maharastrasldc --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-maharastrasldc --id.name maharastrasldcadmin --id.secret maharastrasldcadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:18054 --caname ca-maharastrasldc -M "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/msp" --csr.hosts peer0.maharastrasldc.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:18054 --caname ca-maharastrasldc -M "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.maharastrasldc.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/tlsca/tlsca.maharastrasldc.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/peers/peer0.maharastrasldc.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/ca/ca.maharastrasldc.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:18054 --caname ca-maharastrasldc -M "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/users/User1@maharastrasldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/users/User1@maharastrasldc.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://maharastrasldcadmin:maharastrasldcadminpw@localhost:18054 --caname ca-maharastrasldc -M "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/users/Admin@maharastrasldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/maharastrasldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/maharastrasldc.mpower.in/users/Admin@maharastrasldc.mpower.in/msp/config.yaml"
}

function createRajasthanSldc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/rajasthansldc.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminrajsldc:adminpw@localhost:19054 --caname ca-rajasthansldc --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-rajasthansldc.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-rajasthansldc.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-rajasthansldc.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-rajasthansldc.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-rajasthansldc --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-rajasthansldc --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-rajasthansldc --id.name rajasthansldcadmin --id.secret rajasthansldcadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:19054 --caname ca-rajasthansldc -M "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/msp" --csr.hosts peer0.rajasthansldc.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:19054 --caname ca-rajasthansldc -M "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.rajasthansldc.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/tlsca/tlsca.rajasthansldc.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/peers/peer0.rajasthansldc.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/ca/ca.rajasthansldc.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:19054 --caname ca-rajasthansldc -M "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/users/User1@rajasthansldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/users/User1@rajasthansldc.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://rajasthansldcadmin:rajasthansldcadminpw@localhost:19054 --caname ca-rajasthansldc -M "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/users/Admin@rajasthansldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rajasthansldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rajasthansldc.mpower.in/users/Admin@rajasthansldc.mpower.in/msp/config.yaml"
}

function createWesternRldc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/westernrldc.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminwestrldc:adminpw@localhost:20054 --caname ca-westernrldc --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-20054-ca-westernrldc.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-20054-ca-westernrldc.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-20054-ca-westernrldc.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-20054-ca-westernrldc.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-westernrldc --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-westernrldc --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-westernrldc --id.name westernrldcadmin --id.secret westernrldcadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:20054 --caname ca-westernrldc -M "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/msp" --csr.hosts peer0.westernrldc.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:20054 --caname ca-westernrldc -M "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.westernrldc.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/tlsca/tlsca.westernrldc.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/peers/peer0.westernrldc.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/ca/ca.westernrldc.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:20054 --caname ca-westernrldc -M "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/users/User1@westernrldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/users/User1@westernrldc.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://westernrldcadmin:westernrldcadminpw@localhost:20054 --caname ca-westernrldc -M "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/users/Admin@westernrldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/westernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/westernrldc.mpower.in/users/Admin@westernrldc.mpower.in/msp/config.yaml"
}

function createNorthernRldc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/northernrldc.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/

  set -x
  fabric-ca-client enroll -u https://adminnorthrldc:adminpw@localhost:21054 --caname ca-northernrldc --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-northernrldc.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-northernrldc.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-northernrldc.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-northernrldc.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-northernrldc --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-northernrldc --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-northernrldc --id.name northernrldcadmin --id.secret northernrldcadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:21054 --caname ca-northernrldc -M "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/msp" --csr.hosts peer0.northernrldc.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:21054 --caname ca-northernrldc -M "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.northernrldc.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/tlsca/tlsca.northernrldc.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/peers/peer0.northernrldc.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/ca/ca.northernrldc.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:21054 --caname ca-northernrldc -M "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/users/User1@northernrldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/users/User1@northernrldc.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://northernrldcadmin:northernrldcadminpw@localhost:21054 --caname ca-northernrldc -M "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/users/Admin@northernrldc.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/northernrldc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/northernrldc.mpower.in/users/Admin@northernrldc.mpower.in/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/mpower.in

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/mpower.in

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/mpower.in/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/msp" --csr.hosts orderer.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/mpower.in/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls" --enrollment.profile tls --csr.hosts orderer.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/msp/tlscacerts/tlsca.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/mpower.in/orderers/orderer.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/mpower.in/msp/tlscacerts/tlsca.mpower.in-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/mpower.in/users/Admin@mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/mpower.in/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/mpower.in/users/Admin@mpower.in/msp/config.yaml"
}

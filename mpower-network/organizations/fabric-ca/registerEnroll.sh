#!/bin/bash

function createMul() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/mul.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/mul.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-mul --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mul.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mul.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mul.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-mul.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/mul.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-mul --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-mul --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-mul --id.name muladmin --id.secret muladminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-mul -M "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/msp" --csr.hosts peer0.mul.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-mul -M "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.mul.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/mul.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mul.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/mul.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mul.mpower.in/tlsca/tlsca.mul.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/mul.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/peers/peer0.mul.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/mul.mpower.in/ca/ca.mul.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-mul -M "${PWD}/organizations/peerOrganizations/mul.mpower.in/users/User1@mul.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mul.mpower.in/users/User1@mul.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://muladmin:muladminpw@localhost:7054 --caname ca-mul -M "${PWD}/organizations/peerOrganizations/mul.mpower.in/users/Admin@mul.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mul/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mul.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mul.mpower.in/users/Admin@mul.mpower.in/msp/config.yaml"
}

function createAeml() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/aeml.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/aeml.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-aeml --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aeml.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aeml.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aeml.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-aeml.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/aeml.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-aeml --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-aeml --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-aeml --id.name aemladmin --id.secret aemladminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-aeml -M "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/msp" --csr.hosts peer0.aeml.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-aeml -M "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.aeml.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/aeml.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aeml.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/aeml.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/aeml.mpower.in/tlsca/tlsca.aeml.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/aeml.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/peers/peer0.aeml.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/aeml.mpower.in/ca/ca.aeml.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-aeml -M "${PWD}/organizations/peerOrganizations/aeml.mpower.in/users/User1@aeml.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aeml.mpower.in/users/User1@aeml.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://aemladmin:aemladminpw@localhost:8054 --caname ca-aeml -M "${PWD}/organizations/peerOrganizations/aeml.mpower.in/users/Admin@aeml.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/aeml/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/aeml.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/aeml.mpower.in/users/Admin@aeml.mpower.in/msp/config.yaml"
}

function createGetco() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/getco.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/getco.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:16054 --caname ca-getco --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-getco.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-getco.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-getco.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-16054-ca-getco.pem
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
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:16054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/msp" --csr.hosts peer0.getco.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:16054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/peers/peer0.getco.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.getco.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
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
  fabric-ca-client enroll -u https://user1:user1pw@localhost:16054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/User1@getco.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/User1@getco.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://getcoadmin:getcoadminpw@localhost:16054 --caname ca-getco -M "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/Admin@getco.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/getco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/getco.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/getco.mpower.in/users/Admin@getco.mpower.in/msp/config.yaml"
}

function createMsetcl() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/msetcl.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/msetcl.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:15054 --caname ca-msetcl --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-msetcl.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-msetcl.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-msetcl.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-msetcl.pem
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
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/msp" --csr.hosts peer0.msetcl.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/peers/peer0.msetcl.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.msetcl.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
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
  fabric-ca-client enroll -u https://user1:user1pw@localhost:15054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/User1@msetcl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/User1@msetcl.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://msetcladmin:msetcladminpw@localhost:15054 --caname ca-msetcl -M "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/Admin@msetcl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/msetcl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/msetcl.mpower.in/users/Admin@msetcl.mpower.in/msp/config.yaml"
}

function createPgcil() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/pgcil.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/pgcil.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:13054 --caname ca-pgcil --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-pgcil.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-pgcil.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-pgcil.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-pgcil.pem
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
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/msp" --csr.hosts peer0.pgcil.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/peers/peer0.pgcil.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.pgcil.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
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
  fabric-ca-client enroll -u https://user1:user1pw@localhost:13054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/User1@pgcil.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/User1@pgcil.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://pgciladmin:pgciladminpw@localhost:13054 --caname ca-pgcil -M "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/Admin@pgcil.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/pgcil/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/pgcil.mpower.in/users/Admin@pgcil.mpower.in/msp/config.yaml"
}

function createRrvpnl() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/rrvpnl.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:14054 --caname ca-rrvpnl --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-rrvpnl.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-14054-ca-rrvpnl.pem
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
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:14054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/msp" --csr.hosts peer0.rrvpnl.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:14054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/peers/peer0.rrvpnl.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.rrvpnl.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
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
  fabric-ca-client enroll -u https://user1:user1pw@localhost:14054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/User1@rrvpnl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/User1@rrvpnl.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://rrvpnladmin:rrvpnladminpw@localhost:14054 --caname ca-rrvpnl -M "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/Admin@rrvpnl.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rrvpnl/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rrvpnl.mpower.in/users/Admin@rrvpnl.mpower.in/msp/config.yaml"
}

function createAdaniBitta() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/adanibitta.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-adanibitta --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-adanibitta.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-adanibitta.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-adanibitta.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-adanibitta.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-adanibitta --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-adanibitta --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-adanibitta --id.name adanibittaadmin --id.secret adanibittaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-adanibitta -M "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/msp" --csr.hosts peer0.adanibitta.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-adanibitta -M "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.adanibitta.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/tlsca/tlsca.adanibitta.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/peers/peer0.adanibitta.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/ca/ca.adanibitta.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-adanibitta -M "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/users/User1@adanibitta.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/users/User1@adanibitta.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://adanibittaadmin:adanibittaadminpw@localhost:10054 --caname ca-adanibitta -M "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/users/Admin@adanibitta.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanibitta/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanibitta.mpower.in/users/Admin@adanibitta.mpower.in/msp/config.yaml"
}

function createAdaniKawai() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/adanikawai.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:12054 --caname ca-adanikawai --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-adanikawai.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-adanikawai.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-adanikawai.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-adanikawai.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-adanikawai --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-adanikawai --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-adanikawai --id.name adanikawaiadmin --id.secret adanikawaiadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca-adanikawai -M "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/msp" --csr.hosts peer0.adanikawai.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca-adanikawai -M "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.adanikawai.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/tlsca/tlsca.adanikawai.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/peers/peer0.adanikawai.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/ca/ca.adanikawai.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:12054 --caname ca-adanikawai -M "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/users/User1@adanikawai.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/users/User1@adanikawai.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://adanikawaiadmin:adanikawaiadminpw@localhost:12054 --caname ca-adanikawai -M "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/users/Admin@adanikawai.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanikawai/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanikawai.mpower.in/users/Admin@adanikawai.mpower.in/msp/config.yaml"
}

function createAdaniMundra() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/adanimundra.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:17054 --caname ca-adanimundra --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-adanimundra.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-adanimundra.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-adanimundra.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-17054-ca-adanimundra.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-adanimundra --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-adanimundra --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-adanimundra --id.name adanimundraadmin --id.secret adanimundraadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:17054 --caname ca-adanimundra -M "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/msp" --csr.hosts peer0.adanimundra.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:17054 --caname ca-adanimundra -M "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.adanimundra.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/tlsca/tlsca.adanimundra.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/peers/peer0.adanimundra.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/ca/ca.adanimundra.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:17054 --caname ca-adanimundra -M "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/users/User1@adanimundra.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/users/User1@adanimundra.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://adanimundraadmin:adanimundraadminpw@localhost:17054 --caname ca-adanimundra -M "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/users/Admin@adanimundra.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanimundra/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanimundra.mpower.in/users/Admin@adanimundra.mpower.in/msp/config.yaml"
}

function createAdaniTiroda() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/adanitiroda.mpower.in/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-adanitiroda --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-adanitiroda.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-adanitiroda.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-adanitiroda.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-adanitiroda.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-adanitiroda --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-adanitiroda --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-adanitiroda --id.name adanitirodaadmin --id.secret adanitirodaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-adanitiroda -M "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/msp" --csr.hosts peer0.adanitiroda.mpower.in --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-adanitiroda -M "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls" --enrollment.profile tls --csr.hosts peer0.adanitiroda.mpower.in --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/keystore/"* "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/tlsca"
  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/tlsca/tlsca.adanitiroda.mpower.in-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/ca"
  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/peers/peer0.adanitiroda.mpower.in/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/ca/ca.adanitiroda.mpower.in-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-adanitiroda -M "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/users/User1@adanitiroda.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/users/User1@adanitiroda.mpower.in/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://adanitirodaadmin:adanitirodaadminpw@localhost:11054 --caname ca-adanitiroda -M "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/users/Admin@adanitiroda.mpower.in/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/adanitiroda/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/msp/config.yaml" "${PWD}/organizations/peerOrganizations/adanitiroda.mpower.in/users/Admin@adanitiroda.mpower.in/msp/config.yaml"
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

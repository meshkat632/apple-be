Overview
Create a root CA (offline) on your PC

Use it to issue an intermediate CA cert

Upload the intermediate CA cert + private key as a Kubernetes Secret

Create a ClusterIssuer in cert-manager that uses this CA

Issue private certs in the cluster (signed by intermediate, trusted by root)

### 1. Generate a Root CA (Offline on your PC)
````
openssl genrsa -out vvc-root-ca.key 4096
openssl req -x509 -new -nodes -key vvc-root-ca.key -sha256 -days 3650 -out vvc-root-ca.crt \
  -subj "/C=EU/ST=OfflineRoot/L=Munich/O=ververica/CN=vvc-root-ca"
````
### 2. Generate an Intermediate CA (signed by root) whcich is used to sign the certs by linkerd identy service

```
openssl genrsa -out linkerd-issuer-ca.key 4096
```

# CSR (certificate signing request)
```
openssl req -new -key linkerd-issuer-ca.key -out linkerd-issuer-ca.csr \
  -subj "/CN=linkerd-issuer-ca"
```

# Sign the CSR with the root CA
```
openssl x509 -req -in linkerd-issuer-ca.csr -CA vvc-root-ca.crt -CAkey vvc-root-ca.key \
-CAcreateserial -out linkerd-issuer-ca.crt -days 1825 -sha256 \
-extfile <(printf "basicConstraints=CA:TRUE,pathlen:0\nkeyUsage=critical,keyCertSign,cRLSign")

```



####  example values.yaml
```
linkerdTrustRoot:
  caCrt: |
    -----BEGIN CERTIFICATE-----
    ********************************************
    -----END CERTIFICATE-----
  tlsCrt: |
    -----BEGIN CERTIFICATE-----
    ********************************************
    -----END CERTIFICATE-----
  tlsKey: |
    -----BEGIN _PRIVATE KEY-----
    ********************************************
    -----END _PRIVATE KEY-----

```

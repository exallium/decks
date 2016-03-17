## Build Notes

On El Capitan, to get HsOpenSSL:
```
brew install openssl
cabal install
    --extra-include-dirs=/usr/local/opt/openssl/include
    --extra-lib-dirs=/usr/local/opt/openssl/lib
    --reinstall HsOpenSSL
```

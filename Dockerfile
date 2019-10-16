FROM ipfs/go-ipfs:v0.4.22
LABEL mantainer "Alexander Yammine"

RUN ipfs init && ipfs bootstrap rm --all
FROM ipfs/go-ipfs
LABEL mantainer "Alexander Yammine"

RUN ipfs init && ipfs bootstrap rm --all
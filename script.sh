# ## Init ipfs network
# docker-compose up -d

# sleep 4

## Remove all nodes
docker exec -it ipfs0 ipfs bootstrap rm --all
docker exec -it ipfs1 ipfs bootstrap rm --all
docker exec -it ipfs2 ipfs bootstrap rm --all
docker exec -it ipfs3 ipfs bootstrap rm --all

sleep 2

## Save info
docker exec -it ipfs0 ipfs id > ipfs_data/ipfs0.json
docker exec -it ipfs1 ipfs id > ipfs_data/ipfs1.json
docker exec -it ipfs2 ipfs id > ipfs_data/ipfs2.json
docker exec -it ipfs3 ipfs id > ipfs_data/ipfs3.json


data=`jq -r .ID < ./ipfs_data/ipfs1.json`
addr='/dnsaddr/ipfs1/tcp/4001/ipfs/'${data}

docker exec -it ipfs0 ipfs bootstrap add ${addr}

data=`jq -r .ID < ./ipfs_data/ipfs0.json`
addr='/dnsaddr/ipfs0/tcp/4001/ipfs/'${data}

docker exec -it ipfs1 ipfs bootstrap add ${addr}
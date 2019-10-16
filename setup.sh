function up () {
    export CLUSTER_SECRET=$(od  -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')
    ## Build containers
    docker-compose build

    ## Init ipfs network
    if [[ ( $2 == "-d" || $2 == "daemon" ) ]]
    then
        docker-compose up -d
    else
        docker-compose up &
    fi

    echo "Preparing containers, this will take a while ..."
    sleep 25

    echo "Removing all public nodes"
    ## Remove all public nodes
    docker exec -it ipfs0 ipfs bootstrap rm --all
    docker exec -it ipfs1 ipfs bootstrap rm --all
    docker exec -it ipfs2 ipfs bootstrap rm --all
    docker exec -it ipfs3 ipfs bootstrap rm --all

    sleep 15

    echo "Save ipfs IDs to generates multiaddrs"
    ## Save ipfs IDs and generates Multiaddr
    docker exec -it ipfs0 ipfs id > ipfs_data/ipfs0.json
    docker exec -it ipfs1 ipfs id > ipfs_data/ipfs1.json
    docker exec -it ipfs2 ipfs id > ipfs_data/ipfs2.json
    docker exec -it ipfs3 ipfs id > ipfs_data/ipfs3.json

    data=`jq -r .ID < ./ipfs_data/ipfs0.json`
    addr0='/dnsaddr/ipfs0/tcp/4001/ipfs/'${data}
    data=`jq -r .ID < ./ipfs_data/ipfs1.json`
    addr1='/dnsaddr/ipfs1/tcp/4001/ipfs/'${data}
    data=`jq -r .ID < ./ipfs_data/ipfs2.json`
    addr2='/dnsaddr/ipfs2/tcp/4001/ipfs/'${data}
    data=`jq -r .ID < ./ipfs_data/ipfs3.json`
    addr3='/dnsaddr/ipfs3/tcp/4001/ipfs/'${data}

    echo "Add private nodes to the network"
    ## Add private nodes to ipfs bootstrap list
    docker exec -it ipfs0 ipfs bootstrap add ${addr1}
    docker exec -it ipfs0 ipfs bootstrap add ${addr2}
    docker exec -it ipfs0 ipfs bootstrap add ${addr3}

    docker exec -it ipfs1 ipfs bootstrap add ${addr0}
    docker exec -it ipfs1 ipfs bootstrap add ${addr2}
    docker exec -it ipfs1 ipfs bootstrap add ${addr3}

    docker exec -it ipfs2 ipfs bootstrap add ${addr0}
    docker exec -it ipfs2 ipfs bootstrap add ${addr1}
    docker exec -it ipfs2 ipfs bootstrap add ${addr3}

    docker exec -it ipfs3 ipfs bootstrap add ${addr0}
    docker exec -it ipfs3 ipfs bootstrap add ${addr1}
    docker exec -it ipfs3 ipfs bootstrap add ${addr2}
}

function down() {
    if [[ ( $2 == "--volumes" || $2 == "volumes" ) ]]
    then
        echo "Removing volumes ..."
        docker-compose down --volumes
    else
        docker-compose down
    fi
}

if [[ ( $0 == "./setup.sh" && $1 == "up" ) ]]
then
    echo "Running containers ..."
    up
    exit 0
fi

if [[ ( $0 == "./setup.sh" && $1 == "down" ) ]]
then
    echo "Removing containers ..."
    down
    exit 0
fi
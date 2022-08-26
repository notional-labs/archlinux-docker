#!/bin/bash
# microtick and bitcanna contributed significantly here.
# Pebbledb state sync script.
set -uxe

git clone https://github.com/evmos/evmos --branch release/v7.0.x
cd evmos

# Set Golang environment variables.
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# Install with pebbledb
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@136c7b6
go mod tidy
go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb' -tags pebbledb ./...

# NOTE: ABOVE YOU CAN USE ALTERNATIVE DATABASES, HERE ARE THE EXACT COMMANDS
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=rocksdb' -tags rocksdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=badgerdb' -tags badgerdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=boltdb' -tags boltdb ./...

# Initialize chain.
evmosd init test --chain-id evmos_9000-1

# Get Genesis
wget https://archive.evmos.org/mainnet/genesis.json
mv genesis.json ~/.evmosd/config/


# Get "trust_hash" and "trust_height".
INTERVAL=1000
LATEST_HEIGHT=$(curl -s https://evmos-rpc.polkachu.com/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL))
TRUST_HASH=$(curl -s "https://evmos-rpc.polkachu.com/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Print out block and transaction hash from which to sync state.
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"

# Export state sync variables.
export EVMOSD_STATESYNC_ENABLE=true
export EVMOSD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export EVMOSD_STATESYNC_RPC_SERVERS="https://rpc-evmos-ia.notional.ventures:443,https://evmos-rpc.polkachu.com:443"
export EVMOSD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export EVMOSD_STATESYNC_TRUST_HASH=$TRUST_HASH

# Fetch and set list of seeds from chain registry.
export EVMOSD_P2P_SEEDS=$(curl -s https://raw.githubusercontent.com/cosmos/chain-registry/master/evmos/chain.json | jq -r '[foreach .peers.seeds[] as $item (""; "\($item.id)@\($item.address)")] | join(",")')

# Start chain.
evmosd start --x-crisis-skip-assert-invariants --db_backend pebbledb
faddat@Whites-MacBook-Pro evmos % cat ss.bash
#!/bin/bash
# microtick and bitcanna contributed significantly here.
# Pebbledb state sync script.
set -uxe

git clone https://github.com/evmos/evmos --branch release/v7.0x
cd evmos

# Set Golang environment variables.
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# Install with pebbledb
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@136c7b6
go mod tidy
go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb' -tags pebbledb ./...

# NOTE: ABOVE YOU CAN USE ALTERNATIVE DATABASES, HERE ARE THE EXACT COMMANDS
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=rocksdb' -tags rocksdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=badgerdb' -tags badgerdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=boltdb' -tags boltdb ./...

# Initialize chain.
evmosd init test --chain-id evmos_9000-1

# Get Genesis
wget https://archive.evmos.org/mainnet/genesis.json
mv genesis.json ~/.evmosd/config/


# Get "trust_hash" and "trust_height".
INTERVAL=1000
LATEST_HEIGHT=$(curl -s https://evmos-rpc.polkachu.com/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL))
TRUST_HASH=$(curl -s "https://evmos-rpc.polkachu.com/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Print out block and transaction hash from which to sync state.
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"

# Export state sync variables.
export EVMOSD_STATESYNC_ENABLE=true
export EVMOSD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export EVMOSD_STATESYNC_RPC_SERVERS="https://rpc-evmos-ia.notional.ventures:443,https://evmos-rpc.polkachu.com:443"
export EVMOSD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export EVMOSD_STATESYNC_TRUST_HASH=$TRUST_HASH

# Fetch and set list of seeds from chain registry.
export EVMOSD_P2P_SEEDS=$(curl -s https://raw.githubusercontent.com/cosmos/chain-registry/master/evmos/chain.json | jq -r '[foreach .peers.seeds[] as $item (""; "\($item.id)@\($item.address)")] | join(",")')

# Start chain.
evmosd start --x-crisis-skip-assert-invariants --db_backend pebbledb

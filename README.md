# Howto

### Init the chain
```
bin/create_key alice
NODE_NAME=alice bin/init_blockchain 6
```

### Start the node
```
NODE_NAME=alice bin/start_node
```

### View chain state
```
curl http://localhost:7001/state | jq
```

### View wallet state
```
curl http://localhost:7002/info | jq
```

### Mine a block
```
curl -X POST http://localhost:7002/mine
```

### Send coins somewhere
```
curl -X POST -d '
  {
    "destination": "0698290dd9c46accadba5da29a1c436efa5e3ebca80da532df95d6395527c24b",
    "millis": 10
  }
' http://localhost:7002/send_coins
```

# Changelog

## Oct 11-13, 2024
- [x] Migrate to new block format.
- [x] Migrate from accounts to UTXOs.

## Oct 10, 2024
- [x] `Typed: strict` everywhere

## Oct 5, 2024
- [x] Ensure that an address always has a positive balance
- [x] Add private route: /balance
- [x] Add private route: /send_coins
- [x] Refactor validations.

## Oct 4, 2024
- [x] Split web interface into public and private ones running on different ports

## Oct 3, 2024
- [x] Sign a tx. Ensure that txs in blockchain are signed

## Oct 2, 2024
- [x] Load or init ed25519 key when Node starts
- [x] Generate a coin when adding a new block

## Oct 1, 2024
- [x] Run miner in background

## Sep 30, 2024
- [x] Setup sorbet

## Sep 2024 | 28-29
- [x] Node
- [x] Web interface to interact with Node
  - [x] Route: View state (mempool + blockchain)
  - [x] Route: Mine block
  - [x] Route: Add transaction
- [x] Blockchain: loaded/saved from file
- [x] Blockchain: Ensure that each block correctly references previous one
- [x] Blockchain: Ensure that each block has a valid proof

# TODO

- Review RuleSets. Implement all the necessary block rules

- [ ] Wallet: Working with multiple keys/addresses as with a single wallet.
- [ ] Review RuleSets

- [ ] Transaction: check against UTXO when adding to mempool & blockchain
- [ ] ***Implement consensus
- [ ] Tx: leave some coins as a fee; state it explicitly
- [ ] Allow to record a name on the blockchain somehow (in tx, or outside)

- [ ] Ensure that there's only one coinbase tx in a block, and ensure the reward is correct (== 100 initially)

- [ ] Tx versioning
- [ ] Start a 24/7 node
- [ ] EVM?
- [ ] Web::PrivateInterface, Web::PublicInterface: ractors, not threads

- [ ] Spec for BlockValidator
- [ ] Ensure that app is thread-safe (Consensus, sending coins, mining a block)

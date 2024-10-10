# Howto

### Start the node
```
bundle exec
NODE_NAME=alice ./bin/start_node
```

# TODO
- [ ] Tx: multiple in, multiple out. Replace BalanceRegistry with UTXO
- [ ] Transaction: check against UTXO when adding to mempool & blockchain
- [ ] ***Implement consensus
- [ ] Tx: leave some coins as a fee; state it explicitly
- [ ] Allow to record a name on the blockchain somehow (in tx, or outside)

- [ ] Ensure that there's only one coinbase tx in a block, and ensure the reward is correct (== 100 initially)

- [ ] Tx versioning
- [ ] Start a 24/7 node
- [ ] EVM?
- [ ] Web::PrivateInterface, Web::PublicInterface: ractors, not threads

- [ ] Tx.amount should be integer
- [ ] Spec for BlockValidator
- [ ] Ensure that app is thread-safe (Consensus, sending coins, mining a block)

# Changelog

## Oct 10, 2024
- [x] Typed: strict everywhere, except Roda apps

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
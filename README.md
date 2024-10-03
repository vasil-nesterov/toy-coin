# TODO
-
- [ ] UTXO: one sender, one recipient
- [ ] Transaction: check against UTXO when adding to mempool & blockchain
- [ ] txs, multiple in -> multiple out
- [ ] **Implement consensus

- [ ] Tx versioning
- [ ] Start a 24/7 node
- [ ] EVM?

# Changelog

## Oct 3, 2024
- [x] Transaction signing.
  - Sign coinbase tx with miner's key
  - Check that signature is valid when adding to mempool

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
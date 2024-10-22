# typed: strict

class Block < T::Struct
  CURRENT_VERSION = 2
  
  extend T::Sig

  # TODO: prop :at, Time
  prop :ver, Integer
  prop :prev_dgst, String
  prop :nonce, Integer
  prop :txs, T::Array[Tx]

  # TODO: Rename to something singular
  prop :chain_tweaks, T.nilable(ChainTweaks)
end

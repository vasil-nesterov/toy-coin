# typed: strict

require 'sorbet-runtime'

class Block < T::Struct
  CURRENT_VERSION = 2
  
  extend T::Sig

  prop :version, Integer
  prop :prev_dgst, String
  prop :nonce, Integer
  prop :chain_tweaks, T.nilable(T::Hash[String, T.untyped]) # TODO: Rename to chain_updates
  prop :sig_txs, T::Array[SigTx]

  sig { params(payload: T::Hash[String, T.untyped]).returns(Block) }
  def self.from_hash(payload)
    new(
      version: payload['version'],
      prev_dgst: payload['prev_dgst'],
      nonce: payload['nonce'],
      chain_tweaks: payload['chain_tweaks'],
      sig_txs: payload['sig_txs'].map { |sig_tx| SigTx.from_hash(sig_tx) }
    )
  end
end

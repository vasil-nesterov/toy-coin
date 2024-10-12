# typed: strict

require 'sorbet-runtime'

class Block < T::Struct
  CURRENT_VERSION = 2
  
  extend T::Sig

  prop :version, Integer
  prop :prev_dgst, String
  prop :nonce, Integer
  prop :txs, T::Array[Tx]

  # TODO: Rename to chain_updates
  # TODO: Convert to a proper struct
  prop :chain_tweaks, T.nilable(T::Hash[Symbol, T.untyped])

  sig { params(payload: T::Hash[String, T.untyped]).returns(Block) }
  def self.from_hash(payload)
    new(
      version: payload['version'],
      prev_dgst: payload['prev_dgst'],
      nonce: payload['nonce'],
      chain_tweaks: payload['chain_tweaks'],
      txs: payload['txs'].map { |tx| Tx.from_hash(tx) }
    )
  end
end

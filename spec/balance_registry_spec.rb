RSpec.describe BalanceRegistry do
  let(:registry) { BalanceRegistry.new }

  def add_txs(*txs)
    registry.process_block(
      Block.new(
        index: 0,
        timestamp: Time.now,
        proof: 0,
        previous_block_digest: '',
        transactions: txs
      )
    )
  end

  it 'initializes with an empty balance' do
    expect(registry.balance('alice')).to eq(0)
  end

  describe '#add_block' do
    let(:coinbase_tx) { Transaction.new_coinbase(recipient: 'alice', value: 1.0) }
    let(:tx) { Transaction.new(sender: 'alice', recipient: 'bob', value: 0.5) }

    it 'can add a coinbase transaction' do
      add_txs(coinbase_tx)

      expect(registry.balance('alice')).to eq(1.0)
    end

    it 'can add a transaction' do
      add_txs(coinbase_tx, tx)

      expect(registry.balance('alice')).to eq(0.5)
      expect(registry.balance('bob')).to eq(0.5)
    end

    it 'fails when the sender does not have enough balance' do
      expect {
        add_txs(tx)
      }.to raise_error(BalanceRegistry::SenderHasNotEnoughCoinsError)
    end
  end
end

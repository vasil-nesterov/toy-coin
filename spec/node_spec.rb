# typed: strict

RSpec.describe Node do
  T.bind(self, T.untyped)

  let(:blockchain_storage) { 
    BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") 
  }
  let(:node) { Node.new(blockchain_storage: blockchain_storage) }

  describe '#to_representation' do
    it 'returns the Node state' do
      expect(node.to_representation).to be_a(Hash)
    end
  end

  describe '#add_block' do
    it 'adds a valid block to the blockchain' do
      expect { 
        result, errors = node.add_block(simple_next_block) 
        
        expect(errors).to be_empty
        expect(result).to be(true)
      }.to change { 
        node.to_representation["blockchain"].length 
      }.by(1)
    end

    it 'rejects an invalid block' do
      invalid_next_block = simple_next_block.tap { _1.nonce = 124 } 
      
      expect { 
        result, errors = node.add_block(invalid_next_block) 
        
        expect(errors).not_to be_empty
        expect(result).to be(false)
      }.not_to change { 
        node.to_representation["blockchain"].length 
      }
    end
  end

  describe '#add_tx' do
    it 'adds a valid transaction to the mempool' do
      expect { 
        result, errors = node.add_tx(simple_tx)

        expect(errors).to be_empty
        expect(result).to be(true)
      }.to change { 
        node.to_representation["mempool"].length 
      }.by(1)
    end

    it 'rejects an invalid transaction' do
      invalid_tx = simple_tx.tap { _1.dgst = "" }

      expect { 
        result, errors = node.add_tx(invalid_tx)

        expect(errors).not_to be_empty
        expect(result).to be(false)
      }.not_to change { 
        node.to_representation["mempool"].length 
      }
    end
  end
end

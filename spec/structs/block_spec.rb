# typed: strict

RSpec.describe Block do
  T.bind(self, T.untyped)

  it "creates a block from attributes" do
    expect( 
      Block.new(
        ver: Block::CURRENT_VERSION,
        prev_dgst: "previous_digest",
        nonce: 12345,
        txs: [],
        chain_tweaks: nil
      )
    ).to be_a(Block)
  end
end
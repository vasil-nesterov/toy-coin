# typed: strict

RSpec.describe PrivateKey do
  T.bind(self, T.untyped)

  let(:path) { "#{ROOT_DIR}/spec/fixtures/alice_test.key" }
  let(:private_key) { KeyStorage.new(path).read[:private_key] }

  describe ".generate" do
    let(:private_key) { PrivateKey.generate } 

    it "generates a new private key" do
      expect(private_key).to be_a(PrivateKey)
    end
  end

  describe "#sign" do
    let(:signature) { private_key.sign("test data") }

    it "signs data and returns a signature" do
      expect(signature).to be_a(String)
      expect(signature.length).to eq(128)
    end
  end

  describe "#hex" do
    it "returns the hex representation of the private key" do
      expect(private_key.hex).to eq(
        "1627ad3d56989d4c0f70ac96f2548c032f46cfb28dafd0f9feefb90bbd7ddab7"
      )
    end
  end

  describe "#public_key" do
    let(:public_key) { private_key.public_key }

    it "returns the corresponding public key" do
      expect(public_key).to be_a(PublicKey)
      expect(public_key.hex).to eq(
        "33060d2c78b2d40e529763f9e0cf901463ca2b8f75061412caded25a1382cc1c"
      )
    end
  end
end

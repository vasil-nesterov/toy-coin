# typed: strict

RSpec.describe PublicKey do
  T.bind(self, T.untyped)

  let(:hex) { "92b843ffb0851e3275867396f215a7e6421846a53d4f8fc699d41bbc36dd791d" }
  let(:public_key) { PublicKey.new(hex) }

  describe "#hex" do
    it "returns the hex representation of the PublicKey" do
      expect(public_key.hex).to eq(hex)
    end
  end

  describe "#verify" do
    let(:data) { "herp-derp" }
    let(:signature) { "abe47ab367ea23c7252c08a0b992ab5f6c53440d9456f5e29bf32c953b025aabb65b52239079856883788b28869c2b16e306bbf8616ce8345bc429b44edd560f" }

    it "returns true when the signature is valid" do
      expect(public_key.verify_signature(data:, signature:)).to be(true)
    end

    it "returns false when the signature is invalid" do
      data = "derp-herp"
      expect(public_key.verify_signature(data:, signature:)).to be(false)
    end
  end
end

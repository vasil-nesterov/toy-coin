# typed: false

describe String do
  let(:hex) { "fef359681e0718da983cb19674c93683d1db7efebed262407cfbb5f0d5d9a14b" }

  it "can be converted to bytes and back" do
    expect(
      hex.to_bytes.to_hex
    ).to eq(hex)
  end
end
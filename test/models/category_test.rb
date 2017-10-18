require "test_helper"

describe Category do
  let(:category) { categories(:cupcakes) }

  it "must have a name to be valid" do
    value(category).must_be :valid?
  end
end

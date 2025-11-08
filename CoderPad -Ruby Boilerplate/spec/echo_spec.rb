# frozen_string_literal: true

require "echo"

RSpec.describe Echo do
  it "returns the specified string" do
    echo = Echo.new
    expect(echo.repeat("a sound")).to eq "a sound"
  end

  it "returns the uppercased version of the specified string" do
    echo = Echo.new
    expect(echo.loudly("a loud sound")).to eq "A LOUD SOUND"
  end
end

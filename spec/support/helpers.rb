module Helpers
  def expect_json_response_is_paginated(json_response)
    expect(json_response.dig(:links, :first)).to_not be_nil
    expect(json_response.dig(:links, :last)).to_not be_nil
    expect(json_response.dig(:links, :prev)).to_not be_nil
    expect(json_response.dig(:links, :next)).to_not be_nil
  end
end

defmodule RiverWeb.JWT.Token.Test do
  use River.DataCase, async: true

  describe "token/1" do
    test "adds claims to the token" do
      token = RiverWeb.JWT.Token.token(%{foo: "bar"})
      {:ok, claims} = RiverWeb.JWT.Token.get_claims(token)
      assert claims["foo"] == "bar"
    end
  end
end

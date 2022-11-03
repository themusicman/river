defmodule RiverWeb.JWT.Auth.Test do
  use River.DataCase, async: true

  alias RiverWeb.JWT.{Auth, Token}

  describe "get_claims_from_bearer_token/1" do
    test "returns claims from a valid token" do
      token = Token.token(%{foo: "bar"})
      assert {:ok, %{"foo" => "bar"}} = Auth.get_claims_from_bearer_token(token)
    end
  end
end

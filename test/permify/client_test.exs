defmodule Permify.ClientTest do
  use Permify.HttpCase, async: true

  alias Permify.Client, as: Subject

  describe "new/1" do
    test "returns a Client struct" do
      url = "https://my.permify.io:3476/v1"

      assert %Subject{http_client: %Req.Request{options: %{base_url: ^url}}} = Subject.new(url)
    end
  end

  describe "get/2" do
    test "with 200 returns a successful tuple", %{bypass: bypass, bypass_client: client} do
      Bypass.expect_once(bypass, "GET", "/v1/hello", fn conn ->
        json_resp(conn, 200, ~s<"world">)
      end)

      assert {:ok, "world"} == Subject.get(client, "/hello")
    end

    test "with 400 returns an error tuple", %{bypass: bypass, bypass_client: client} do
      Bypass.expect_once(bypass, "GET", "/v1/hello", fn conn ->
        json_resp(conn, 400, ~s<{"errors": {"unknown": "Unknown error"}}>)
      end)

      assert {:error, %{"unknown" => "Unknown error"}} == Subject.get(client, "/hello")
    end

    test "with 500 returns an error tuple", %{bypass: bypass, bypass_client: client} do
      Bypass.expect_once(bypass, "GET", "/v1/hello", fn conn ->
        Plug.Conn.resp(conn, 500, "Internal server error")
      end)

      # Prevent the retry logic delaying the test result
      req_options = client.http_client.options |> Map.merge(%{retry: :never}) |> Map.to_list()
      client = %{client | http_client: Req.new(req_options)}

      assert {:error, 500} == Subject.get(client, "/hello")
    end
  end
end

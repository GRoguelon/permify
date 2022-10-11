defmodule Permify.ServerTest do
  use Permify.HttpCase, async: true

  alias Permify.Server, as: Subject

  describe "ping/1" do
    test "with 200 returns pong", %{client: client} do
      assert {:ok, "pong"} == Subject.ping(client)
    end
  end

  describe "version/1" do
    test "with 200 returns version", %{client: client} do
      assert {:ok, "v0.0.0-alpha6"} == Subject.version(client)
    end
  end
end

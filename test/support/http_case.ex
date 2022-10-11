defmodule Permify.HttpCase do
  @moduledoc """
  Provides a convenient way to test the modules interacting with the service.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Permify.HttpCase
    end
  end

  setup do
    bypass = Bypass.open()

    {:ok,
     bypass: bypass,
     bypass_client: Permify.Client.new("http://localhost:#{bypass.port}/v1"),
     client: Permify.Client.new("http://localhost:#{System.get_env("PERMIFY_ENV", "3476")}/v1"),
     version: Application.get_env(:permify, :schema_version)}
  end

  def json_resp(conn, status, body) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json; charset=UTF-8")
    |> Plug.Conn.put_resp_header("server", "Cowboy")
    |> Plug.Conn.resp(status, body)
  end
end

defmodule Permify.Server do
  @moduledoc """
  Provides some information about the service.
  """

  alias Permify.Client

  ## Types

  @type pong :: binary()

  @type version :: binary()

  ## Public functions

  @doc """
  Checks the status of the service by sending a `ping` and expects to return `pong`.
  """
  @spec ping(Client.t()) :: {:ok, pong()} | Client.error()
  def ping(%Client{} = client) do
    with {:ok, %{"message" => message}} <- Client.get(client, "/status/ping") do
      {:ok, message}
    end
  end

  @doc """
  Returns the version of the service.
  """
  @spec version(Client.t()) :: {:ok, version()} | Client.error()
  def version(%Client{} = client) do
    with {:ok, %{"version" => version}} <- Client.get(client, "/status/version") do
      {:ok, version}
    end
  end
end

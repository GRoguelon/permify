defmodule Permify.Schema do
  @moduledoc """
  Provides some functions to manipulate the Permify schema.
  """
  alias Permify.Client

  ## Types

  @type schema :: binary()

  @type read_resp :: map()

  @type lookup_req :: %{entity_type: binary(), relation_names: [binary()], schema_version: Permify.schema_version()}

  @type lookup_resp :: [binary()]

  ## Public functions

  @doc """
  Read your authorization model
  """
  @spec read(Client.t(), Permify.schema_version()) :: {:ok, read_resp()} | Client.error()
  def read(%Client{} = client, schema_version) do
    Client.post(client, "/schemas/read", %{schema_version: schema_version})
  end

  @doc """
  Write your authorization model
  """
  @spec write(Client.t(), schema()) :: {:ok, Permify.schema_version()} | Client.error()
  def write(%Client{} = client, schema) when is_binary(schema) do
    with {:ok, %{"version" => schema_version}} <- Client.upload_schema(client, "/schemas/write", schema) do
      {:ok, schema_version}
    end
  end

  @doc """
  Lookup your authorization model
  """
  @spec lookup(Client.t(), lookup_req()) :: {:ok, lookup_resp()} | Client.error()
  def lookup(%Client{} = client, request) do
    with {:ok, %{"action_names" => action_names}} <- Client.post(client, "/schemas/lookup", request) do
      {:ok, action_names}
    end
  end
end

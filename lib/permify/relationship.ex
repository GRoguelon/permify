defmodule Permify.Relationship do
  @moduledoc """
  Provides some functions to manipulate the relationships.
  """

  alias Permify.Client

  ## Types

  @type schema_version :: binary()

  @type relation :: binary()

  @type entity :: %{required(:id) => binary(), required(:type) => binary()}

  @type subject :: %{required(:id) => binary(), optional(:relation) => relation(), required(:type) => binary()}

  @type read_req :: %{
          :filter => %{
            :entity => entity(),
            :relation => relation(),
            :subject => subject()
          }
        }

  @type read_resp :: [map()]

  @type write_req :: %{
          required(:entity) => entity(),
          required(:relation) => binary(),
          required(:subject) => subject(),
          optional(:schema_version) => binary()
        }

  @type write_resp :: map()

  @type delete_req :: %{required(:entity) => entity(), required(:relation) => binary(), required(:subject) => subject()}

  @type delete_resp :: map()

  ## Public functions

  @doc """
  Read relation tuple(s)
  """
  @spec read(Client.t(), read_req()) :: {:ok, read_resp()} | Client.error()
  def read(%Client{} = client, request) do
    Client.post(client, "/relationships/read", %{filter: request})
  end

  @doc """
  Create new relation tuple
  """
  @spec write(Client.t(), write_req()) :: {:ok, write_resp()} | Client.error()
  def write(%Client{} = client, request) do
    Client.post(client, "/relationships/write", request)
  end

  @doc """
  Delete relation tuple
  """
  @spec delete(Client.t(), delete_req()) :: {:ok, delete_resp()} | Client.error()
  def delete(%Client{} = client, request) do
    Client.post(client, "/relationships/delete", request)
  end
end

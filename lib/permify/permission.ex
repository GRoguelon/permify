defmodule Permify.Permission do
  @moduledoc """
  Provides some functions to check the permissions.
  """

  alias Permify.Client

  ## Types

  @type depth :: non_neg_integer()

  @type action :: binary()

  @type entity :: Permify.Relationship.entity()

  @type subject :: Permify.Relationship.subject()

  @type check_req :: %{
          required(:action) => action(),
          optional(:depth) => depth(),
          required(:entity) => entity(),
          optional(:schema_version) => Permify.schema_version(),
          required(:subject) => subject()
        }

  ## Public functions

  @doc """
  Check subject is authorized
  """
  @spec check?(Client.t(), check_req()) :: boolean()
  def check?(%Client{} = client, request) do
    case check(client, request) do
      {:ok, %{"can" => can}} ->
        can

      _ ->
        false
    end
  end

  @doc """
  Check subject is authorized
  """
  @spec check(Client.t(), check_req()) :: any()
  def check(%Client{} = client, request) do
    Client.post(client, "/permissions/check", request)
  end

  @doc """
  Expand relationships according to schema
  """
  @spec expand(Client.t(), any()) :: any()
  def expand(%Client{} = client, request) do
    Client.post(client, "/permissions/expand", request)
  end
end

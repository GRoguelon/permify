defmodule Permify.Client do
  @moduledoc """
  Provides some helpers to call the service via HTTP.
  """

  @enforce_keys [:http_client]
  defstruct [:http_client]

  ## Types

  @type t :: %__MODULE__{http_client: http_client()}

  @opaque http_client :: Req.Request.t()

  @type success :: :ok | {:ok, any()}

  @type error :: {:error, binary()} | {:error, pos_integer()}

  ## Public functions

  @doc """
  Creates a new struct `__MODULE__ |> Module.split() |> Enum.join(".")`.
  """
  @spec new(binary() | URI.t()) :: t()
  def new(endpoint \\ "http://localhost:3476/v1") do
    uri = URI.parse(endpoint)
    http_client = Req.new(base_url: URI.to_string(uri), decode_body: true)

    %__MODULE__{http_client: http_client}
  end

  @doc """
  Defines a helper to make HTTP GET request.
  """
  @spec get(t(), binary()) :: success() | error()
  def get(%__MODULE__{http_client: http_client}, path) do
    http_client |> Req.get!(url: path) |> parse_response()
  end

  @doc """
  Defines a helper to make HTTP POST request.
  """
  @spec post(t(), binary(), any()) :: success() | error()
  def post(%__MODULE__{http_client: http_client}, path, body) do
    http_client |> Req.post!(url: path, json: body) |> parse_response
  end

  @multipart_boundary "PERMIFY-SCHEMA"

  @doc """
  Defines a helper to upload the Permify schema.
  """
  @spec upload_schema(t(), binary(), binary()) :: success() | error()
  def upload_schema(%__MODULE__{http_client: http_client}, path, schema) do
    body = generate_upload_body(schema)

    http_client
    |> Req.Request.put_header("Content-Type", "multipart/form-data; boundary=#{@multipart_boundary}")
    |> Req.post!(url: path, body: body)
    |> parse_response()
  end

  ## Private functions

  # Parses the response and extract the valuable information wrapped into :ok or :error tuple.
  @spec parse_response(Req.Response.t()) :: success() | error()
  def parse_response(%Req.Response{status: status, body: %{"data" => data}}) when status in 200..299 do
    {:ok, data}
  end

  def parse_response(%Req.Response{status: status, body: body}) when status in 200..299 and not is_nil(body) do
    {:ok, body}
  end

  def parse_response(%Req.Response{status: status, body: %{"errors" => errors}}) when status in 400..499 do
    {:error, errors}
  end

  def parse_response(%Req.Response{status: status, body: %{"message" => message}}) when status in 400..499 do
    {:error, message}
  end

  def parse_response(%Req.Response{status: status, body: body}) when status in 400..499 and not is_nil(body) do
    {:error, body}
  end

  def parse_response(%Req.Response{status: status}) do
    {:error, status}
  end

  # Defines a helper to generate the upload HTTP query body.
  @spec generate_upload_body(binary()) :: binary()
  def generate_upload_body(schema) do
    "--#{@multipart_boundary}\n" <>
      ~s<Content-Disposition: form-data; name="schema"; filename="schema.perm"\n> <>
      "Content-Type: application/octet-stream\r\n\r\n" <>
      schema <>
      "\r\n\r\n--#{@multipart_boundary}--"
  end
end

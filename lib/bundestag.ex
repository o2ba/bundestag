defmodule Bundestag do
  @moduledoc """
  Elixir client for the German Bundestag DIP API.

  ## Usage

      client = Bundestag.client("your-api-key")

      client
      |> Bundestag.persons()
      |> Enum.take(5)
  """

  alias Bundestag.Client
  alias Bundestag.Model.{Person, PersonParams, ListResponse}

  @doc """
  Creates a new client with the given API key.

  ## Options

    * `:base_url` - Override the API base URL (useful for testing)

  ## Examples

      iex> client = Bundestag.client("your-api-key")
      %Bundestag.Client{api_key: "your-api-key", base_url: "https://search.dip.bundestag.de/api/v1"}
  """
  def client(api_key, opts \\ []), do: Client.new(api_key, opts)

  @doc """
  Returns a stream of persons from the Bundestag API.

  Results are lazily fetched and paginated automatically.

  ## Examples

      # Fetch first 10 persons
      client |> Bundestag.persons() |> Enum.take(10)

      # Filter by name
      client
      |> Bundestag.persons(%PersonParams{name: "Merkel, Angela"})
      |> Enum.to_list()
  """
  def persons(%Client{} = client, params \\ %PersonParams{}) do
    Stream.unfold(params, fn
      nil ->
        nil

      params ->
        case fetch_page(client, params) do
          {:ok, %{documents: docs, cursor: nil}} -> {docs, nil}
          {:ok, %{documents: docs, cursor: cursor}} -> {docs, %{params | cursor: cursor}}
          {:error, _} -> nil
        end
    end)
    |> Stream.flat_map(& &1)
  end

  defp fetch_page(%Client{api_key: api_key, base_url: base_url}, params) do
    url = "#{base_url}/person"
    headers = [{"Authorization", "ApiKey #{api_key}"}]
    query = PersonParams.to_query(params)

    url
    |> Req.get(headers: headers, params: query)
    |> handle_response()
  end

  defp handle_response({:ok, %{status: 200, body: body}}) do
    persons = body["documents"] |> Enum.map(&Person.from_map/1)
    {:ok, %ListResponse{numFound: body["numFound"], cursor: body["cursor"], documents: persons}}
  end

  defp handle_response({:ok, %{status: 401}}), do: {:error, :unauthorized}
  defp handle_response({:ok, %{status: status}}), do: {:error, status}
end

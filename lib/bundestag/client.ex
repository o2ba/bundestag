defmodule Bundestag.Client do
  alias Bundestag.Model.{Person, PersonParams, ListResponse}

  @base_url "https://search.dip.bundestag.de/api/v1"

  def get_persons(api_key, params \\ %PersonParams{}) do
    url = "#{@base_url}/person"
    headers = [{"Authorization", "ApiKey #{api_key}"}]
    params = PersonParams.to_query(params)

    url
    |> Req.get(headers: headers, params: params)
    |> handle_response()
  end

  defp handle_response({:ok, %{status: 200, body: body}}) do
    persons = body["documents"] |> Enum.map(fn doc -> Person.from_map(doc) end)

    {:ok, %ListResponse{numFound: body["numFound"], cursor: body["cursor"], documents: persons}}
  end

  defp handle_response({:ok, %{status: 401}}) do
    {:error, :unauthorized}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, status}
  end

  def stream_persons(api_key, params \\ %PersonParams{}) do
    Stream.unfold(params, fn
      nil ->
        nil

      params ->
        case get_persons(api_key, params) do
          {:ok, %{documents: docs, cursor: nil}} -> {docs, nil}
          {:ok, %{documents: docs, cursor: cursor}} -> {docs, %{params | cursor: cursor}}
          {:error, _} -> nil
        end
    end)
    |> Stream.flat_map(& &1)
  end
end

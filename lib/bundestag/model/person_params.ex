defmodule Bundestag.Model.PersonParams do
  defstruct [
    :name,
    :cursor,
    :election_period
  ]

  def to_query(%__MODULE__{} = params) do
    [format: "json"]
    |> add_param(:"f.person", params.name)
    |> add_param(:cursor, params.cursor)
    |> add_param(:"f.wahlperiode", params.election_period)
  end

  defp add_param(query, _key, nil), do: query
  defp add_param(query, key, value), do: [{key, value} | query]
end

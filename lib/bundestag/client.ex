defmodule Bundestag.Client do
  defstruct [:api_key, :base_url]

  def new(api_key, opts \\ []) do
    %__MODULE__{
      api_key: api_key,
      base_url: opts[:base_url] || "https://search.dip.bundestag.de/api/v1"
    }
  end
end

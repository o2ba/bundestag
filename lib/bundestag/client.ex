defmodule Bundestag.Client do
  defstruct [:api_key]

  def new(api_key) do
    %__MODULE__{api_key: api_key}
  end
end

# Bundestag

Elixir client for the [German Bundestag DIP API](https://search.dip.bundestag.de/api/v1/swagger-ui/#).

## Installation

Add `bundestag` to your dependencies in `mix.exs`:
```elixir
def deps do
  [
    {:bundestag, "~> 1.0"}
  ]
end
```

## Usage
```elixir
# Create a client
client = Bundestag.client("your-api-key")

# Stream all persons
client
|> Bundestag.persons()
|> Enum.take(10)

# Filter by name
alias Bundestag.Model.PersonParams

client
|> Bundestag.persons(%PersonParams{name: "Merkel, Angela"})
|> Enum.to_list()
```

Results are lazily streamed, pagination is handled automatically.

## API Key

Get your API key from the [Bundestag API portal](https://dip.bundestag.de/%C3%BCber-dip/hilfe/api).

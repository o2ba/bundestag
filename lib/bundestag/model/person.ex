defmodule Bundestag.Model.Person do
  alias Bundestag.Model.{FederalState, PersonRole}

  defstruct([
    :last_updated,
    :id,
    :title,
    :first_name,
    :last_name,
    :nobility_particle,
    :type,
    :role,
    :role_qualifier,
    :faction,
    :constituency,
    :ministry,
    :federal_state,
    :election_period,
    :base_date,
    :date,
    :person_roles
  ])

  def from_map(map) do
    %__MODULE__{
      last_updated: map["aktualisiert"] |> parse_datetime(),
      id: map["id"],
      title: map["titel"],
      first_name: map["vorname"],
      last_name: map["nachname"],
      nobility_particle: map["namenszusatz"],
      type: map["typ"],
      role: map["funktion"] |> List.wrap(),
      role_qualifier: map["funktionszusatz"],
      faction: map["fraktion"] |> List.wrap(),
      constituency: map["wahlkreiszusatz"],
      ministry: map["ressort"],
      federal_state: map["bundesland"] |> List.wrap() |> Enum.map(&FederalState.from_string/1),
      election_period: map["wahlperiode"] |> List.wrap(),
      base_date: map["basisdatum"] |> parse_date(),
      date: map["datum"] |> parse_date(),
      person_roles: map["person_roles"] |> List.wrap() |> Enum.map(&PersonRole.from_map/1)
    }
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(date_string) do
    case DateTime.from_iso8601(date_string) do
      {:ok, datetime, _} -> datetime
      _ -> nil
    end
  end

  defp parse_date(nil), do: nil

  defp parse_date(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> date
      _ -> nil
    end
  end
end

defmodule Bundestag.Model.PersonRole do
  alias Bundestag.Model.FederalState

  defstruct [
    :role,
    :role_qualifier,
    :faction,
    :last_name,
    :first_name,
    :nobility_particle,
    :election_periods,
    :constituency,
    :ministry,
    :federal_state
  ]

  def from_map(map) do
    %__MODULE__{
      role: map["funktion"],
      role_qualifier: map["funktionszusatz"],
      faction: map["fraktion"],
      first_name: map["vorname"],
      last_name: map["nachname"],
      nobility_particle: map["namenszusatz"],
      election_periods: map["wahlperiode_nummer"] |> List.wrap(),
      constituency: map["wahlkreiszusatz"],
      ministry: map["ressort_titel"],
      federal_state: map["bundesland"] |> List.wrap() |> Enum.map(&FederalState.from_string/1)
    }
  end
end

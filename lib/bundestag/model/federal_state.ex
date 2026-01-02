defmodule Bundestag.Model.FederalState do
  @mapping %{
    "Baden-Württemberg" => :baden_wuerttemberg,
    "Bayern" => :bayern,
    "Berlin" => :berlin,
    "Brandenburg" => :brandenburg,
    "Bremen" => :bremen,
    "Hamburg" => :hamburg,
    "Hessen" => :hessen,
    "Mecklenburg-Vorpommern" => :mecklenburg_vorpommern,
    "Niedersachsen" => :niedersachsen,
    "Nordrhein-Westfalen" => :nordrhein_westfalen,
    "Rheinland-Pfalz" => :rheinland_pfalz,
    "Saarland" => :saarland,
    "Sachsen" => :sachsen,
    "Sachsen-Anhalt" => :sachsen_anhalt,
    "Schleswig-Holstein" => :schleswig_holstein,
    "Thüringen" => :thueringen
  }

  def from_string(str), do: Map.get(@mapping, str, :unknown)
end

defmodule BundestagTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open()
    client = Bundestag.client("test-key", base_url: "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass, client: client}
  end

  test "persons/2 streams paginated results", %{bypass: bypass, client: client} do
    Bypass.expect(bypass, "GET", "/person", fn conn ->
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.resp(
        200,
        Jason.encode!(%{
          "numFound" => 1,
          "cursor" => nil,
          "documents" => [
            %{
              "id" => 14,
              "funktion" => ["Bundeskanzl."],
              "nachname" => "Merkel",
              "vorname" => "Angela",
              "typ" => "Person",
              "wahlperiode" => [12, 13, 14, 15, 16, 17, 18, 19],
              "aktualisiert" => "2022-07-26T19:57:10+02:00"
            }
          ]
        })
      )
    end)

    [person] = client |> Bundestag.persons() |> Enum.to_list()

    assert person.first_name == "Angela"
    assert "Bundeskanzl." in person.role
  end

  test "persons/2 handles unauthorized", %{bypass: bypass, client: client} do
    Bypass.expect(bypass, "GET", "/person", fn conn ->
      Plug.Conn.resp(conn, 401, "")
    end)

    result = client |> Bundestag.persons() |> Enum.to_list()

    assert result == []
  end
end

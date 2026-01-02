defmodule BundestagTest do
  use ExUnit.Case
  doctest Bundestag

  test "greets the world" do
    assert Bundestag.hello() == :world
  end
end

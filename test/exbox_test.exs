defmodule ExBoxTest do
  use ExUnit.Case
  doctest ExBox

  test "creates a box" do
    expected = "┌─────┐\n│hello│\n└─────┘"
    actual = ExBox.get("hello") |> IO.iodata_to_binary

    assert actual == expected
  end

  test "padding option" do
    expected = "┌─────────────────┐\n│                 │\n│                 │\n│      hello      │\n│                 │\n│                 │\n└─────────────────┘"
    actual = ExBox.get("hello", [padding: 2]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "padding option advanced" do
    padding_opts = [top: 0, bottom: 2, left: 5, right: 10]
    expected = "┌────────────────────┐\n│     hello          │\n│                    │\n│                    │\n└────────────────────┘"
    actual = ExBox.get("hello", [padding: padding_opts]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "margin option" do
    expected = "\n\n      ┌─────────────────┐\n      │                 │\n      │                 │\n      │      hello      │\n      │                 │\n      │                 │\n      └─────────────────┘\n\n"
    actual = ExBox.get("hello", [padding: 2, margin: 2]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "float center" do
    expected = "                                                                         ┌─────┐\n                                                                         │hello│\n                                                                         └─────┘"
    actual = ExBox.get("hello", [float: :center]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "round border style" do
    expected = "╭─────╮\n│hello│\n╰─────╯"
    actual = ExBox.get("hello", [border_style: :round]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "double border style" do
    expected = "╔═════╗\n║hello║\n╚═════╝"
    actual = ExBox.get("hello", [border_style: :double]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "single double border style" do
    expected = "╓─────╖\n║hello║\n╙─────╜"
    actual = ExBox.get("hello", [border_style: :single_double]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "double single border style" do
    expected = "╒═════╕\n│hello│\n╘═════╛"
    actual = ExBox.get("hello", [border_style: :double_single]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "classic border style" do
    expected = "+-----+\n|hello|\n+-----+"
    actual = ExBox.get("hello", [border_style: :classic]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "border color option" do
    expected = "\e[38;5;3m┌─────┐\e[0m\n\e[38;5;3m│\e[0mhello\e[38;5;3m│\e[0m\n\e[38;5;3m└─────┘\e[0m"
    actual = ExBox.get("hello", border_color: :yellow) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "background color option" do
    expected = "┌─────┐\n│\e[48;5;1mhello\e[0m│\n└─────┘"
    actual = ExBox.get("hello", bg_color: :red) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "align center" do
    expected = "┌───────────┐\n│           │\n│   hello   │\n│           │\n└───────────┘"
    actual = ExBox.get("hello", [align: :center, padding: 1]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "align right" do
    expected = "┌───────┐\n│  hello│\n│goodbye│\n└───────┘"
    actual = ExBox.get("hello\ngoodbye", [align: :right]) |> IO.iodata_to_binary

    assert actual == expected
  end

  test "align left" do
    expected = "┌───────┐\n│hello  │\n│goodbye│\n└───────┘"
    actual = ExBox.get("hello\ngoodbye", [align: :left]) |> IO.iodata_to_binary

    assert actual == expected
  end
end

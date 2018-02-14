defmodule ExStringTest.ANSI do
  use ExUnit.Case
  alias ExBox.ANSI

  defp red(str), do: "#{IO.ANSI.red()}#{str}#{IO.ANSI.reset()}"
  defp bright(str), do: "#{IO.ANSI.bright()}#{str}#{IO.ANSI.reset()}"
  defp cyan(str), do: "#{IO.ANSI.cyan()}#{str}#{IO.ANSI.reset()}"

  test "strips ANSI escape codes" do
    str_a = "\u001b[4m\u001b[42m\u001b[31mfoo\u001b[39m\u001b[49m\u001b[24mfoo"
    str_b = "\u001b[00;38;5;244m\u001b[m\u001b[00;38;5;33mfoo\u001b[0m"
    str_c = "\x1b[0;33;49;3;9;4mbar\x1b[0m"

    assert ANSI.strip(str_a) == "foofoo"
    assert ANSI.strip(str_b) == "foo"
    assert ANSI.strip(str_c) == "bar"
  end

  test "align supports ANSI" do
    input = "#{red("one")}" <> " two " <> "#{bright("three\n")}" <> "#{cyan("four ")}" <> "five"

    output =
      "#{red("one")}" <> " two " <> "#{bright("three\n  ")}" <> "#{cyan("four ")}" <> "five"

    assert ANSI.align(input) == output
  end

  test "aligns center, splits line feed, and pads with space by default" do
    input = "one two three\nfour five"
    output = "one two three\n  four five"

    assert ANSI.align(input) == output
  end

  test "accepts opts for split, pad, and align" do
    input = "one two\tthree four five"
    output = "........one two\tthree four five"

    assert ANSI.align(input, align: :right, pad: ".", split: "\t") == output
  end

  test "center align" do
    input = " one \n two \n three four \n five "
    output = "    one \n    two \n three four \n    five "

    assert ANSI.align(input) == output
  end

  test "left align (noop)" do
    input = " one \n two \n three four \n five "

    assert ANSI.align(input, align: :left) == input
  end

  test "right align" do
    input = "one\ntwo three\nfour\nfive"
    output = "      one\ntwo three\n     four\n     five"

    assert ANSI.align(input, align: :right) == output
  end
end

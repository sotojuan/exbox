defmodule ExBox.Width do
  @moduledoc """
  String and character widths utilities.
  """

  alias ExBox.ANSI

  @doc """
  Get the visual width of a string

  Visual width means the number of columns required to display a string
  """
  @spec string(String.t) :: non_neg_integer
  def string(""), do: 0
  def string(string) do
    string
    |> ANSI.strip
    |> String.to_charlist
    |> Enum.reduce(0, &width_reducer/2)
  end

  defp width_reducer(c, count) do
    cond do
      # Control characters don't count
      (c <= 0x1f || (c >= 0x7f && c <= 0x9f)) ->
        count
      (c >= 0x10000) ->
        count + 1
      is_fullwidth_char(c) ->
        count + 2
      true ->
        count + 1
    end
  end

  @doc """
  Get the visual width of the widest line in a string

  Visual width means the number of columns required to display a string
  """
  @spec widest_line(String.t) :: non_neg_integer
  def widest_line(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn(s) -> string(s) end)
    |> Enum.max
  end

  @doc """
  Check if the character represented by a given Unicode code point is fullwidth

  https://en.wikipedia.org/wiki/Halfwidth_and_fullwidth_forms
  """
  @spec is_fullwidth_char(char) :: boolean
  def is_fullwidth_char(''), do: false
  def is_fullwidth_char(c) when is_list(c), do: is_fullwidth_char(hd(c))
  def is_fullwidth_char(c) do
    c >= 0x1100 && (
    c <= 0x115f || # Hangul Jamo
    c == 0x2329 || # LEFT-POINTING ANGLE BRACKET
    c == 0x232a || # RIGHT-POINTING ANGLE BRACKET
    # CJK Radicals Supplement - Enclosed CJK Letters and Months
    (0x2e80 <= c && c <= 0x3247 && c !== 0x303f) ||
    # CJK Unified Ideographs - Yi Radicals
    (0x4e00 <= c && c <= 0xa4c6) ||
    # Hangul Jamo Extended-A
    (0xa960 <= c && c <= 0xa97c) ||
    # Hangul Syllables
    (0xac00 <= c && c <= 0xd7a3) ||
    # CJK Compatibility Ideographs
    (0xf900 <= c && c <= 0xfaff) ||
    # Vertical Forms
    (0xfe10 <= c && c <= 0xfe19) ||
    # CJK Compatibility Forms - Small Form Variants
    (0xfe30 <= c && c <= 0xfe6b) ||
    # Halfwidth and Fullwidth Forms
    (0xff01 <= c && c <= 0xff60) ||
    (0xffe0 <= c && c <= 0xffe6) ||
    # Kana Supplement
    (0x1b000 <= c && c <= 0x1b001) ||
    # Enclosed Ideographic Supplement
    (0x1f200 <= c && c <= 0x1f251) ||
    # CJK Unified Ideographs Extension B - Tertiary Ideographic Plane
    (0x20000 <= c && c <= 0x3fffd))
  end
end

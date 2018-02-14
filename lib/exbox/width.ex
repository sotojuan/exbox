defmodule ExBox.Width do
  @moduledoc """
  String and character widths utilities.
  """

  alias ExBox.ANSI

  @doc """
  Get the visual width of a string

  Visual width means the number of columns required to display a string
  """
  @spec string(String.t()) :: non_neg_integer
  def string(""), do: 0

  def string(string) do
    string
    |> ANSI.strip()
    |> String.to_charlist()
    |> Enum.reduce(0, &width_reducer/2)
  end

  defp width_reducer(c, count) do
    cond do
      # Control characters don't count
      c <= 0x1F || (c >= 0x7F && c <= 0x9F) ->
        count

      c >= 0x10000 ->
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
  @spec widest_line(String.t()) :: non_neg_integer
  def widest_line(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn s -> string(s) end)
    |> Enum.max()
  end

  @doc """
  Check if the character represented by a given Unicode code point is fullwidth

  https://en.wikipedia.org/wiki/Halfwidth_and_fullwidth_forms
  """
  @spec is_fullwidth_char(char) :: boolean
  def is_fullwidth_char(''), do: false
  def is_fullwidth_char(c) when is_list(c), do: is_fullwidth_char(hd(c))

  def is_fullwidth_char(c) do
    # Hangul Jamo
    # LEFT-POINTING ANGLE BRACKET
    # RIGHT-POINTING ANGLE BRACKET
    # CJK Radicals Supplement - Enclosed CJK Letters and Months
    # CJK Unified Ideographs - Yi Radicals
    # Hangul Jamo Extended-A
    # Hangul Syllables
    # CJK Compatibility Ideographs
    # Vertical Forms
    # CJK Compatibility Forms - Small Form Variants
    # Halfwidth and Fullwidth Forms
    # Kana Supplement
    # Enclosed Ideographic Supplement
    # CJK Unified Ideographs Extension B - Tertiary Ideographic Plane
    c >= 0x1100 &&
      (c <= 0x115F || c == 0x2329 || c == 0x232A || (0x2E80 <= c && c <= 0x3247 && c !== 0x303F) ||
         (0x4E00 <= c && c <= 0xA4C6) || (0xA960 <= c && c <= 0xA97C) ||
         (0xAC00 <= c && c <= 0xD7A3) || (0xF900 <= c && c <= 0xFAFF) ||
         (0xFE10 <= c && c <= 0xFE19) || (0xFE30 <= c && c <= 0xFE6B) ||
         (0xFF01 <= c && c <= 0xFF60) || (0xFFE0 <= c && c <= 0xFFE6) ||
         (0x1B000 <= c && c <= 0x1B001) || (0x1F200 <= c && c <= 0x1F251) ||
         (0x20000 <= c && c <= 0x3FFFD))
  end
end

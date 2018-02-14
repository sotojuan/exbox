defmodule ExBox.ANSI do
  @moduledoc """
  ANSI utilities.
  """

  alias ExBox.Width

  @regex ~r/[\x{001b}\x{009b}][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]/

  @doc """
  Strip ANSI escape codes
  """
  @spec strip(String.t()) :: String.t()
  def strip(string) do
    String.replace(string, @regex, "")
  end

  @doc """
  Align text with ANSI support
  """
  # Needs type spec, support ""
  def align(string, options \\ []) do
    opts = Keyword.merge([align: :center, split: "\n", pad: " "], options)

    case opts[:align] do
      :left ->
        string

      _ ->
        align = opts[:align]
        split = opts[:split]
        pad = opts[:pad]
        diff = if align != :right, do: &half_diff/2, else: &full_diff/2

        text = String.split(string, split)
        max_w = max_width(text)

        text
        |> Enum.map(&to_tuple/1)
        |> Enum.map(fn {str, width} ->
          String.duplicate(pad, diff.(max_w, width)) <> str
        end)
        |> Enum.join(split)
    end
  end

  defp max_width(text) do
    text
    |> Enum.map(&Width.string/1)
    |> Enum.max()
  end

  defp to_tuple(str), do: {str, Width.string(str)}

  defp half_diff(max_width, cur_width) do
    div(max_width - cur_width, 2)
  end

  defp full_diff(max_width, cur_width) do
    max_width - cur_width
  end
end

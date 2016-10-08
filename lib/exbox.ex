defmodule ExBox do
  @moduledoc false

  @nl "\n"
  @pad " "

  alias ExBox.Boxes
  alias ExBox.ANSI
  alias ExBox.Width

  def get(text, opts \\ [])

  def get(text, opts) when is_list(text) do
    text
    |> IO.iodata_to_binary
    |> get(opts)
  end

  def get(text, opts) when is_binary(text) do
    default = [
      padding: 0,
      margin: 0,
      border_style: :single,
      dim_border: false,
      align: :left,
      float: :left
    ]

    opts = Keyword.merge(default, opts)

    {cols, _} = TermSize.get
    chars = get_border_chars(opts[:border_style])
    padding = get_list(opts[:padding])
    margin = get_list(opts[:margin])

    text = ANSI.align(text, [align: opts[:align]])
    lines = text |> String.split("\n") |> fill_lines(padding)

    content_width = Width.widest_line(text) + padding[:left] + padding[:right]
    padding_left = duplicate(@pad, padding[:left])
    margin_left = align_left(margin[:left], opts[:float], content_width, cols)

    horizontal = duplicate(chars.horizontal, content_width)
    top = colorize_border([duplicate(@nl, margin[:top]), margin_left, chars.top_left, horizontal, chars.top_right], opts)
    bottom = colorize_border([margin_left, chars.bottom_left, horizontal, chars.bottom_right, duplicate(@nl, margin[:bottom])], opts)
    side = colorize_border(chars.vertical, opts)

    middle =
      lines
      |> Enum.map(
        fn(line) ->
          padding_right = duplicate(@pad, content_width - Width.string(line) - padding[:left])
          [margin_left, side, colorize_content([padding_left, line, padding_right], opts), side]
        end)
      |> Enum.join(@nl)

    [top, @nl, middle, @nl, bottom]
  end

  defp get_list(detail) when is_number(detail) do
    [top: detail, right: detail * 3, bottom: detail, left: detail * 3]
  end

  defp get_list(detail) when is_list(detail) do
    default = [top: 0, right: 0, bottom: 0, left: 0]

    Keyword.merge(default, detail)
  end

  defp get_border_chars(style) when is_atom(style) do
    apply(Boxes, style, [])
  end

  defp colorize_border(x, opts) do
    case Keyword.fetch(opts, :border_color) do
      {:ok, c} ->
        apply(ExChalk, c, [IO.iodata_to_binary(x)])
      :error ->
        x
    end
  end

  defp colorize_content(x, opts) do
    case Keyword.fetch(opts, :bg_color) do
      {:ok, c} ->
        color =
          "bg_"
          |> String.to_charlist
          |> Enum.concat(Atom.to_charlist(c))
          |> List.to_atom

        apply(ExChalk, color, [IO.iodata_to_binary(x)])
      :error ->
        x
    end
  end

  defp duplicate(x, n) do
    List.duplicate([x], n)
  end

  defp fill_lines(lines, padding) do
    top = List.duplicate("", padding[:top])
    bottom = List.duplicate("", padding[:bottom])

    top ++ lines ++ bottom
  end

  defp align_left(margin_left, float, content_width, cols) do
    case float do
      :center ->
        pad_width = div((cols - content_width), 2)
        List.duplicate([@pad], pad_width)
      :right ->
        pad_width = Enum.max([cols - content_width - 3, 0])

        if pad_width < 0 do
          List.duplicate([@pad], 0)
        else
          List.duplicate([@pad], pad_width)
        end
      _ ->
        List.duplicate([@pad], margin_left)
    end
  end
end

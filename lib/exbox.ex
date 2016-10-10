defmodule ExBox do
  @moduledoc """
  Provides a simple interface to text boxes.
  """

  @nl "\n"
  @pad " "

  alias ExBox.Boxes
  alias ExBox.ANSI
  alias ExBox.Width

  @doc """
  Returns a text box with the given text and style options. Text boxes are returned
  in List form, which can be printed.

  To convert to a string, use `IO.iodata_to_binary`.

  **Options**

  ## `border_color`
  Color of the box border.

  Values: `:black :red :green :yellow :blue :magenta :cyan :white :gray :grey`

  ## `background_color`
  Color of the background.

  Values: `:black :red :green :yellow :blue :magenta :cyan :white`

  ## `border_style`
  Style of the box border.

  Default: `:single`

  Values: `:single :double :round :single_double :double_single :classic`

  ## `padding`
  Space between the text and box border.

  Default: `0`

  Accepts a number or an Keyword List with any of the `top`, `right`, `bottom`, `left` properties.
  When a number is specified, the left/right padding is 3 times the top/bottom to make it look nice.

  ## `margin`
  Space around the box.

  Default: `0`

  Accepts a number or an Keyword List with any of the `top`, `right`, `bottom`, `left` properties.
  When a number is specified, the left/right padding is 3 times the top/bottom to make it look nice.

  ## `align`
  Align the text in the box based on the widest line.

  Default: `:left`

  Values: `:left :center :right`

  ## `float`
  Float the box on the available terminal screen space.

  Default: `:left`

  Values: `:right :center :left`

  Examples:

  `"hello" |> ExBox.get`

  `"hello" |> ExBox.get(padding: 5, border_color: :red)`
  """
  @spec get(String.t, Keyword.t) :: List.t
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

    # Merge given options with default, preferring the given
    opts = Keyword.merge(default, opts)

    {cols, _} = TermSize.get
    chars = get_border_chars(opts[:border_style])
    padding = get_list(opts[:padding])
    margin = get_list(opts[:margin])

    # Align the text, handling possible ANSI codes
    text = ANSI.align(text, [align: opts[:align]])
    # Split the lines and add given padding to the top or bottom
    lines = text |> String.split("\n") |> fill_lines(padding)

    # Get the width of the widest line and add the left and right padding
    content_width = Width.widest_line(text) + padding[:left] + padding[:right]
    padding_left = duplicate(@pad, padding[:left])
    # Overwrite left margin depending on given float options (center and right floats need specific numbers)
    margin_left = align_left(margin[:left], opts[:float], content_width, cols)

    # These lines take care of the borders, sizing them to fit the given text
    horizontal = duplicate(chars.horizontal, content_width)
    top = colorize_border([duplicate(@nl, margin[:top]), margin_left, chars.top_left, horizontal, chars.top_right], opts)
    bottom = colorize_border([margin_left, chars.bottom_left, horizontal, chars.bottom_right, duplicate(@nl, margin[:bottom])], opts)
    side = colorize_border(chars.vertical, opts)

    # For each line, add left margin, the side border, padding, text, and the ending side border
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
    # If padding or margin was given as a number, return a list with some default values
    [top: detail, right: detail * 3, bottom: detail, left: detail * 3]
  end

  defp get_list(detail) when is_list(detail) do
    # If padding or margin was given as a list, merge it with some default values
    default = [top: 0, right: 0, bottom: 0, left: 0]

    Keyword.merge(default, detail)
  end

  defp get_border_chars(style) when is_atom(style) do
    # Return the box style by calling the given function in the `Boxes` module

    # For example, an argument of `:classic` will return the call to `Boxes.classic`
    apply(Boxes, style, [])
  end

  defp colorize_border(x, opts) do
    case Keyword.fetch(opts, :border_color) do
      {:ok, c} ->
        # Apply the given color `c` to the string representation of the border characters
        apply(ExChalk, c, [IO.iodata_to_binary(x)])
      :error ->
        x
    end
  end

  defp colorize_content(x, opts) do
    case Keyword.fetch(opts, :bg_color) do
      {:ok, c} ->
        # Apply the given color `c` to the background of the content
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
    # Wrapper over `duplicate` that accepts a string and puts it in a List
    # This is done because we need the result to be a List
    List.duplicate([x], n)
  end

  defp fill_lines(lines, padding) do
    top = List.duplicate("", padding[:top])
    bottom = List.duplicate("", padding[:bottom])

    top ++ lines ++ bottom
  end

  defp align_left(margin_left, float, content_width, cols) do
    # Returns a new left margin depending on arguments given
    # Center and right floats require the correct amount of margin

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

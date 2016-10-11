# exbox

[![Build Status](https://travis-ci.org/sotojuan/exbox.svg?branch=master)](https://travis-ci.org/sotojuan/exbox)

> Create boxes in the terminal

![](https://i.imgur.com/fNjWe8j.png)

Inspired by [boxen](https://github.com/sindresorhus/boxen).

## Install

In your `mix.exs`:

```elixir
defp deps do
  [
    { :exbox, "~> 1.0.0" }
  ]
end
```

Then run `mix deps.get`.

## API

### `ExBox.get(input, [options])`

#### input

Type: `String.t`

Text inside the box.

#### options

Type: `List.t`

##### `border_color`

Color of the box border.

Values: `:black :red :green :yellow :blue :magenta :cyan :white :gray :grey`

##### `background_color`

Color of the background.

Values: `:black :red :green :yellow :blue :magenta :cyan :white`

##### `border_style`

Style of the box border.

Default: `:single`

Values: `:single :double :round :single_double :double_single :classic`

##### `padding`

Space between the text and box border.

Default: `0`

Accepts a number or an Keyword List with any of the `top`, `right`, `bottom`, `left` properties.
When a number is specified, the left/right padding is 3 times the top/bottom to make it look nice.

##### `margin`

Space around the box.

Default: `0`

Accepts a number or an Keyword List with any of the `top`, `right`, `bottom`, `left` properties.
When a number is specified, the left/right padding is 3 times the top/bottom to make it look nice.

##### `align`

Align the text in the box based on the widest line.

Default: `:left`

Values: `:left :center :right`

##### `float`

Float the box on the available terminal screen space.

Default: `:left`

Values: `:right :center :left`

## Examples

Padding:

![](http://i.imgur.com/a8tjoRa.png)

Padding, border style, and margin:

![](http://i.imgur.com/8R3U7jv.png)

Floating the box to the center:

![](http://i.imgur.com/SkOTIhP.png)

Coloring text:

![](http://i.imgur.com/1bTi8HX.png)

ExBox pairs well with [ExChalk](https://github.com/sotojuan/exchalk), which you can use to style text before piping it.

Aligning text:

![](http://i.imgur.com/b9v0oMf.png)

## License

MIT © [Juan Soto](http://juansoto.me)

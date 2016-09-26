defmodule ExBox.BoxesTest do
  use ExUnit.Case

  alias ExBox.Boxes

  test "boxes" do
    assert Boxes.single.top_left == '┌'
  end
end

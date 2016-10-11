defmodule ExBox.Boxes do
  @moduledoc false

  def single do
    %{
      :top_left => "┌",
      :top_right => "┐",
      :bottom_right => "┘",
      :bottom_left => "└",
      :vertical => "│",
      :horizontal => "─"
    }
  end

  def round do
    %{
      :top_left => "╭",
      :top_right => "╮",
      :bottom_right => "╯",
      :bottom_left => "╰",
      :vertical => "│",
      :horizontal => "─"
    }
  end

  def double do
    %{
      :top_left => "╔",
      :top_right => "╗",
      :bottom_right => "╝",
      :bottom_left => "╚",
      :vertical => "║",
      :horizontal => "═"
    }
  end

  def single_double do
    %{
      :top_left => "╓",
      :top_right => "╖",
      :bottom_right => "╜",
      :bottom_left => "╙",
      :vertical => "║",
      :horizontal => "─"
    }
  end

  def double_single do
    %{
      :top_left => "╒",
      :top_right => "╕",
      :bottom_right => "╛",
      :bottom_left => "╘",
      :vertical => "│",
      :horizontal => "═"
    }
  end

  def classic do
    %{
      :top_left => "+",
      :top_right => "+",
      :bottom_right => "+",
      :bottom_left => "+",
      :vertical => "|",
      :horizontal => "-"
    }
  end
end

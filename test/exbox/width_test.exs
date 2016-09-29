defmodule ExStringTest.Width do
  use ExUnit.Case
  alias ExBox.Width

  test "returns true if codepoint is fullwidth" do
    assert true == Width.is_fullwidth_char('あ')
  	assert true == Width.is_fullwidth_char('谢')
  	assert true == Width.is_fullwidth_char('고')
  	assert false == Width.is_fullwidth_char('a')
  end

  test "returns correct string width" do
    assert 5 == Width.string("abcde")
  	assert 6 == Width.string("古池や")
  	assert 9 == Width.string("あいうabc")
  	assert 9 == Width.string("ノード.js")
  	assert 4 == Width.string("你好")
  	assert 10 == Width.string("안녕하세요")
  end

  test "string width ignores control characters" do
    assert 0 == Width.string("\u0000")
    assert 0 == Width.string("\u001f")
    assert 0 == Width.string("\u001b")
  end

  test "gets widest line length in a string" do
    assert 1 == Width.widest_line("a")
    assert 2 == Width.widest_line("a\nbe")
    assert 2 == Width.widest_line("古\n\u001b[1m@\u001b[22m")
  end
end

require 'test_helper'

class IpsumizerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ipsumizer::VERSION
  end

  def test_empty_data_complaint
    begin
      ip = Ipsumizer.new []
      assert false, "empty data error"
    rescue
      assert true, "empty data error"
    end
  end

  def test_negative_prefix_complaint
    begin
      ip = Ipsumizer.new "foo", prefix: -1
      assert false, "negative prefix bad"
    rescue
      assert true, "negative prefix bad"
    end
  end

  def test_zero_prefix_complaint
    begin
      ip = Ipsumizer.new "foo", prefix: 0
      assert false, "zero prefix bad"
    rescue
      assert true, "zero prefix bad"
    end
  end

  def test_default_sentencer
    ip = Ipsumizer.new "foo"
    assert_equal [ "foo. ", "bar" ], ip.sentence("foo. bar"), "recognizes ."
    assert_equal [ "foo! ", "bar" ], ip.sentence("foo! bar"), "recognizes !"
    assert_equal [ "foo? ", "bar" ], ip.sentence("foo? bar"), "recognizes ?"
    assert_equal [ "(foo?) ", "bar" ], ip.sentence("(foo?) bar"), "handles terminals inside parentheses"
    assert_equal [ '"(foo?)" ', "bar" ], ip.sentence('"(foo?)" bar'), "handles quotes"
  end

  def test_custom_sentencer
    ip = Ipsumizer.new "foo", sentencer: /( )/
    assert_equal ['foo ', 'bar'], ip.sentence("foo bar"), "can use custom sentencer"
  end

  def test_speak
    ip = Ipsumizer.new "foo bar"
    assert_equal 'foo bar', ip.speak, "expected result for single-sentence text"
  end

  def test_sentenced
    ip = Ipsumizer.new ["foo bar"]
    assert_equal 'foo bar', ip.speak, "expected result for pre-sentenced single-sentence text"
  end

  def test_multiple_sentence_string_input
    ip = Ipsumizer.new "foo. bar"
    assert ip.speak, "uttered something"
  end

  def test_multiple_sentence_array_input
    ip = Ipsumizer.new [ "foo. ", "bar" ]
    assert ip.speak, "uttered something"
  end

  def test_short_prefix
    ip = Ipsumizer.new "foo", prefix: 1
    assert ip.speak, "uttered something"
  end

  def test_long_prefix
    ip = Ipsumizer.new "foo", prefix: 100
    assert ip.speak, "uttered something"
  end
end

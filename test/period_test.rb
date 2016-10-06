require 'test_helper'

class TestPeriod < MiniTest::Unit::TestCase

  def test_year
    assert_equal 1978, Period.new(1978, 7).year
    assert_equal 1978, Period.new('1978', '7').year
  end

  def test_month
    assert_equal 7, Period.new(1978, 7).month
    assert_equal 7, Period.new('1978', '7').month
  end

  def test_to_i
    assert_equal 197807, Period.new(1978, 7).to_i
    assert_equal 197807, Period.new('1978', '7').to_i
    assert_equal 197807, Period.new(197807).to_i
    assert_equal 197807, Period.new('197807').to_i
    assert_equal 197807, Period.new(Date.new(1978, 7, 29)).to_i
    assert_equal 197807, Period.new(DateTime.new(1978, 7, 29)).to_i
    assert_equal 197807, Period.new(Time.utc(1978, 7, 29)).to_i
  end

  def test_to_s
    assert_equal 'июль 1978', Period.new(1978, 7).to_s
  end

  def test_next
    assert_equal Period.new(1978, 8), Period.new(197807).next
    assert_equal Period.new(197901), Period.new(1978, 12).next
  end

  def test_prior
    assert_equal Period.new(197806), Period.new(1978, 7).prior
    assert_equal Period.new(1978, 12), Period.new(197901).prior
  end

  def test_plus
    assert_equal Period.new(1978, 9), Period.new(1978, 7) + 2
    assert_equal Period.new(1979, 8), Period.new(1978, 7) + 13
  end

  def test_minus
    assert_equal Period.new(1978, 5), Period.new(1978, 7) - 2
    assert_equal Period.new(1977, 6), Period.new(1978, 7) - 13
  end

  def test_diff
    assert_equal 2, Period.new(1978, 7).diff(Period.new(1978, 5))
    assert_equal 13, Period.new(1978, 7).diff(Period.new(1977, 6))
    assert_equal -2, Period.new(1978, 5).diff(Period.new(1978, 7))
    assert_equal -13, Period.new(1977, 6).diff(Period.new(1978, 7))
  end

  def test_current
    assert_equal false, Period.new(1978, 7).current?
    assert_equal true, Period.new(Date.current.year, Date.current.month).current?
  end

  def test_start_of_year
    assert_equal false, Period.new(1978, 7).start_of_year?
    assert_equal true, Period.new(197801).start_of_year?
    assert_equal Period.new(1978, 1), Period.new(197807).start_of_year
  end

  def test_end_of_year
    assert_equal false, Period.new(197807).end_of_year?
    assert_equal true, Period.new(1978, 12).end_of_year?
    assert_equal Period.new(197812), Period.new(1978, 7).end_of_year
  end

end

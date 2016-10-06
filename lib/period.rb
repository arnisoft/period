# -*- coding: utf-8 -*-
require "period/version"

class Period
  include Comparable

  RUS_MONTHS = %w[январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь]

  def initialize(*params)
    case params.size
      when 1
        param = params.first
        case param
          when Date, Time, DateTime
            init_from_date param
          else
            init_solid param
        end
      when 2
        init_separated params.first, params.last
      else
        raise 'Ожидается либо два аргумента Period.new(2012, 10), либо один Period.new(201210), Period.new(Date.new(2012, 10, 30))'
    end
  end

  def year
    @year
  end

  def month
    @month
  end

  def to_i
    @year * 100 + @month
  end

  def to_s
    #'%d, %s' % [@year, RUS_MONTHS[@month - 1]]
    '%s %d' % [RUS_MONTHS[@month - 1], @year]
  end

  def next
    if @month >= 12
      Period.new(@year + 1, 1)
    else
      Period.new(@year, @month + 1)
    end
  end

  def prior
    if @month <= 1
      Period.new(@year - 1, 12)
    else
      Period.new(@year, @month - 1)
    end
  end

  def +(months)
    years, months = split_to_years_months(months)
    years = @year + years
    months = @month + months
    if months > 12
      years += 1
      months -= 12
    end
    Period.new(years, months)
  end

  def -(months)
    years, months = split_to_years_months(months)
    years = @year - years
    months = @month - months
    if months < 1
      years -= 1
      months += 12
    end
    Period.new(years, months)
  end

  # разница в месяцах
  def diff(other)
    (@year - other.year) * 12 + (@month - other.month)
  end

  def current?
    self == Period.current
  end

  def start_of_year?
    @month == 1
  end

  def start_of_year
    Period.new(@year, 1)
  end

  def end_of_year?
    @month == 12
  end

  def end_of_year
    Period.new(@year, 12)
  end

  def <=>(other)
    to_i <=> other.to_i
  end

  def upto(other)
    if block_given?
      value = self
      while value <= other
        yield value
        value = value.next
      end
    end
  end

  def self.current
    today = Date.current
    new(today.year, today.month)
  end


  private

  def init_from_date(date)
    @year = date.year
    @month = date.month
    raise "Некорректный месяц в #{ date.inspect }" unless (1..12).include?(@month)
    raise "Некорректный год в #{ date.inspect }" unless (1900..2100).include?(@year)
  end

  def init_solid(year_month)
    @year = year_month.to_i / 100
    @month = year_month.to_i % 100
    raise "Некорректный месяц в периоде #{ year_month.inspect }" unless (1..12).include?(@month)
    raise "Некорректный год в периоде #{ year_month.inspect }" unless (1900..2100).include?(@year)
  end

  def init_separated(year, month)
    @year = year.to_i
    @month = month.to_i
    raise "Месяца с номером #{ month.inspect } не существует!" unless (1..12).include?(@month)
    raise "Некорректный год: #{ year.inspect }" unless (1900..2100).include?(@year)
  end

  def split_to_years_months(months)
    months = months.to_i
    [months / 12, months % 12]
  end

end

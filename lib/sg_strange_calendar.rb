require 'date'

class SgStrangeCalendar
  def initialize(year, today = nil)
    # write your code here
    @year = year
  end

  def generate(vertical: false)
    # write your code here
    rows = ["#{@year}#{' Su Mo Tu We Th Fr Sa' * 5} Su Mo"]
    (1..12).each do |month|
      first_date = Date.new(@year, month, 1)
      last_date = Date.new(@year, month, -1)
      days = Array.new(first_date.wday, '  ') # wdayで曜日のインデックスを取得(0:日曜, 1:月曜, ..., 6:土曜)
      month_name = first_date.strftime('%b') # strftimeで月名を取得. %bは月名の省略形
      (first_date..last_date).each do |date|
        days << date.day.to_s.rjust(2) # rjust(2)で右寄せ2桁にする
      end

      rows << "#{month_name}  #{days.join(' ')}"
    end

    rows.join("\n")
  end
end

calendar = SgStrangeCalendar.new(2024)
puts calendar.generate

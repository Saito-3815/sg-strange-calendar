require 'date'

YEAR_WIDTH = 4
WDAYS = %w[Su Mo Tu We Th Fr Sa].cycle.take(37) # cycleで無限に繰り返し、take(37)で最初の37個取得

class SgStrangeCalendarLv3
  def initialize(year, today = nil)
    # write your code here
    @year = year
    @today = today
  end

  def generate(vertical: false)
    header_cols, *bodey_table = generate_table(vertical) # 曜日ヘッダーwdaysがheader_colsに、それ以外の日付がbodey_tableに入る
    header_row = header_cols.join(' ')
    body_rows = build_body_rows(bodey_table, vertical)
    [header_row, *body_rows].join("\n")
  end


  private

  def generate_table(vertical)
    # (1..12).mapでも可だが、1.upto(12)の方が直感的かつメモリ効率が良い
    # 1.upto(12)は1から12までのイテレータを返す。(1..12)は範囲オブジェクトを返す。
    dates_by_month = 1.upto(12).map do |month|
      first_date = Date.new(@year, month, 1)
      last_date = Date.new(@year, month, -1)
      # wdayで曜日のインデックスを取得(0:日曜, 1:月曜, ..., 6:土曜)
      # 要素がnilの配列を作成(最終的に作成される配列にdayメソッドを適用することで、日にちと共にnilからは空白が生成される)
      blank_days = Array.new(first_date.wday)
      month_name = first_date.strftime('%b') # strftimeで月名を取得. %bは月名の省略形
      [month_name, *blank_days, *first_date..last_date]
    end
    wdays = [@year, *WDAYS]

    # verticalがtrueで縦向きにする
    # zipメソッドで各配列の同じインデックスの要素をまとめて配列にする
    vertical ? wdays.zip(*dates_by_month) : [wdays, *dates_by_month]
  end

  def build_body_rows(bodey_table, vertical)
    day_width = vertical ? 4 : 3 # 縦向きの場合は4桁、横向きの場合は3桁
    bodey_table.map do |first_col, *dates| # first_colは月名
      build_body_row(first_col, dates, day_width)
    end
  end

  def build_body_row(first_col, dates, day_width)
    days = dates.map do |date|
      bracket = '[' if add_left_bracket?(date)
      # rjust(3)で右寄せ3桁にする(空白が作成される)
      # bracketとdateがnilの場合は空白が返る(dayメソッドがnilに対してnilを返すため)
      "#{bracket}#{date&.day}".rjust(day_width)
    end
    row = [first_col.ljust(YEAR_WIDTH), *days].join
    insert_right_bracket(row).rstrip # rstripで縦向きにした場合に発生する右端の空白を削除
  end

  def add_left_bracket?(date)
    @today && date == @today
  end

  def insert_right_bracket(row)
    # 正規表現で]を追加する
    # マッチした文字列の後に文字列を追加する場合は、\1でマッチした文字列を参照できる
    row.sub(/(\[\d+) ?/, '\1]')
  end
end

today = Date.new(2024, 12, 9)
calendar = SgStrangeCalendarLv3.new(2024, today)
puts calendar.generate(vertical: true)

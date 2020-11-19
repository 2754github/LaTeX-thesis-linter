def file_linter(file_name)
  system("npx textlint #{file_name}")

  error_count = 0
  warning_count = 0
  File.open(file_name, "r:UTF-8") do |file|
    file.each_with_index do |line, i|
      tmp = comma_and_period_rule(line, i)
      error_count += tmp[0]
      warning_count += tmp[1]
      warning_count += formula_rule(line, i)
      error_count += integral_rule(line, i)
      error_count += posix_rule(line, i)
    end
  end

  total_count = error_count + warning_count
  if total_count > 0
    puts "\n" +
    "\e[1m\e[31m" +
    "✖ and #{total_count} problem#{total_count == 1 ? "" : "s"} " +
    "(#{error_count} error#{error_count == 1 ? "" : "s"}, " +
    "#{warning_count} warning#{warning_count == 1 ? "" : "s"})" +
    "\e[m\e[m"
  end
end

def comma_and_period_rule(line, i)
  error_count = 0
  warning_count = 0

  replace_words = {
    "　" => "␣",
    "、" => ",␣",
    "。" => ".␣",
    "，" => ",␣",
    "．" => ".␣",
    "（" => "(",
    "）" => ")"
    }
  replace_words.keys.each do |ng_word|
    line.where_is(ng_word).each do |j|
      ok_word = replace_words[ng_word]
      puts message("error", "全角「#{ng_word}」の代わりに、半角「#{ok_word}」を使用してください。", i, j)
      error_count += 1
    end
  end

  ["," ,"."].each do |word|
    line.where_is(word).each do |j|
      if line[j-1] == " "
        puts message("error", "「#{word}」の前に不要な半角スペースがあります。", i, j)
        error_count += 1
      end
      if line[j-1] != "\\" && line[j+1] != " "
        puts message("error", "「#{word}」の後には半角スペースが必要です。", i, j)
        error_count += 1
      end
    end
  end

  if line[-3] == "," || line[-2] == ","
    puts message("warn", "「,」で文が終了しています。", i, line.length)
    warning_count += 1
  end

  return [error_count, warning_count]
end

def formula_rule(line, i)
  return 0 if line[0] != "$"
  puts message("warn", "文頭が数式です。", i, 0)
  return 1
end

def integral_rule(line, i)
  return 0 unless line.include? "\\int"
  return 0 if line.include? "\\,"
  puts message("error", "被積分関数の後には「\\,」が必要です。", i, line.index("\\int"))
  return 1
end

def posix_rule(line, i)
  return 0 if line[-1] == "\n"
  puts message("error", "ファイルの最後には改行が必要です。", i, line.length)
  return 1
end

def message(severity, sentence, i, j)
  prefix = severity == "error" ? "31" : "33"
  severity = severity.rjust(5, " ")
  line_number = "#{i+1}".rjust(4, " ")
  character_number = "#{j+1}".ljust(4, " ")
  return "\e[90m#{line_number}:#{character_number}\e[m \e[#{prefix}m#{severity}\e[m  #{sentence}"
end

class String
  # https://qiita.com/hirokishirai/items/4ef483adba993255ed65
  def where_is(value) # value が1文字の場合しか正しく動作しない。
    self.split("").map.with_index{|item, i| i if item == value}.compact!
  end
end

file_linter(ARGV[0])

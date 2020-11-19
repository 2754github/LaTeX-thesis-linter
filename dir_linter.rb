def dir_linter(dir_name)
  puts "\n*.texファイルの走査を開始しました。しばらくお待ちください。"

  Dir.glob("#{dir_name}/**/*") do |file_name|
    next unless /^*.tex$/.match(file_name)
    puts "\n========================================"
    puts "\e[1m#{file_name}\e[m"
    system("ruby file_linter.rb #{file_name}")
  end

  puts "\n*.texファイルの走査が終了しました。"
end

dir_linter(ARGV[0])

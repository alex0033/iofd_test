require 'pty'
require 'expect'
require 'fileutils'

@exec_file = "sample.rb"
# exec_file = ARGV[0]

class String
    def colorize(color_code)
      "\e[#{color_code}m#{self}\e[0m"
    end

    def red
      colorize(31)
    end

    def green
      colorize(32)
    end

    def yellow
      colorize(33)
    end

    def pink
      colorize(35)
    end
end

def cofirm_console_output(test_name, inputs, expected_output)
    cmd = "ruby #{@exec_file}"
    PTY.getpty(cmd) do |i, o|
        # 以下のブロックは抽象化の対象
        inputs.each do |input|
            i.expect(input[:assist_input]) do
                o.puts input[:auto_input]
            end
        end
        # 下記でテストが成功か否かを表示
        begin
            i.expect(expected_output, 10) do |line|
                puts "success #{test_name}".green
            end
        rescue => error
            puts "fail #{test_name}".red
            # 出力結果を表示
            # flag???
        end
    end
end

def confirm_file_create(test_name, inputs, expected_file)
    cmd = "ruby #{@exec_file}"
    if File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが存在済み)"
        return
    end
    PTY.getpty(cmd) do |i, o, pid|
        inputs.each do |input|
            i.expect(input[:assist_input]) do
                o.puts input[:auto_input]
            end
        end
        Process.wait pid
    end
    # 下記でテストが成功か否かを表示
    if File.exist?(expected_file)
        puts "success #{test_name}".green
        # リセット
        File.delete expected_file
    else
        puts "fail #{test_name}".red
    end
end

def confirm_new_file(test_name, inputs, expected_file, comparison_file)
    cmd = "ruby #{@exec_file}"
    if File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが存在済み)"
        return
    end
    PTY.getpty(cmd) do |i, o, pid|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
        Process.wait pid
    end
    # 下記でテストが成功か否かを表示
    # 変更する必要性あり
    if File.exist?(expected_file) && FileUtils.cmp(expected_file, comparison_file)
        puts "success #{test_name}".green
    else
        puts "fail #{test_name}".red
    end
    # リセット
    File.delete expected_file if File.exist?(expected_file)
end

def confirm_changed_file(test_name, inputs, expected_file, comparison_file)
    cmd = "ruby #{@exec_file}"
    unless File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが未存在)"
        return
    end
    # 共通化（inputs_check??）
    PTY.getpty(cmd) do |i, o, pid|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
        Process.wait pid
    end
    # 下記でテストが成功か否かを表示
    # 変更する必要性あり
    if File.exist?(expected_file) && FileUtils.cmp(expected_file, comparison_file)
        puts "success #{test_name}".green
    else
        puts "fail #{test_name}".red
    end
    # リセット
end

def confirm_directory_exist(test_name, inputs, expected_directory)
    cmd = "ruby #{@exec_file}"
    if Dir.exist?(expected_directory)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ディレクトリが存在済み)"
        return
    end
    PTY.getpty(cmd) do |i, o, pid|
        inputs.each do |input|
            i.expect(input[:assist_input]) do
                o.puts input[:auto_input]
            end
        end
        # 下記コードでコマンドの終了待ち
        # これによりディレクトリ作成が反映される
        Process.wait pid
    end
    # 下記でテストが成功か否かを表示
    if Dir.exist?(expected_directory)
        puts "success #{test_name}".green
        # 状態のリセット(ディレクトリの削除)
        Dir.rmdir expected_directory
    else
        puts "fail #{test_name}".red
    end
end

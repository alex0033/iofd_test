require 'pty'
require 'expect'
require 'fileutils'

def set_cmd(file_name)
    @cmd = "ruby #{file_name}"
end

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

def auto_input(inputs)
    PTY.getpty(@cmd) do |i, o, pid|
        inputs.each do |input|
            i.expect(input[:assist_input]) do
                o.puts input[:auto_input]
            end
        end
        yield i, o if block_given?
        # 下記コードでコマンドの終了待ち
        # これによりディレクトリやファイル作成が反映される
        Process.wait pid
    end
end

def cofirm_console_output(test_name, inputs, expected_output)    
    auto_input(inputs) do |i, o|
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
    if File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが存在済み)"
        return
    end
    auto_input(inputs)
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
    if File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが存在済み)"
        return
    end
    auto_input(inputs)
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
    unless File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが未存在)"
        return
    end
    copy_file = "copy.txt"
    # ファイルの一時的なコピー
    FileUtils.cp expected_file, copy_file
    auto_input(inputs)
    # 下記でテストが成功か否かを表示
    # 変更する必要性あり
    if File.exist?(expected_file) && FileUtils.cmp(expected_file, comparison_file)
        puts "success #{test_name}".green
    else
        puts "fail #{test_name}".red
    end
    # リセット
    if File.exist?(expected_file)
        FileUtils.cp copy_file, expected_file
    end
    File.delete copy_file
end

def confirm_file_delete(test_name, inputs, expected_file)
    unless File.exist?(expected_file)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ファイルが未存在)"
        return
    end
    copy_file = "copy.txt"
    # ファイルの一時的なコピー
    FileUtils.cp expected_file, copy_file
    auto_input(inputs)
    # 下記でテストが成功か否かを表示
    # 変更する必要性あり
    if File.exist?(expected_file)
        puts "fail #{test_name}".red
    else
        puts "success #{test_name}".green
    end
    # リセット
    unless File.exist?(expected_file)
        FileUtils.cp copy_file, expected_file
    end
    File.delete copy_file
end

def confirm_directory_create(test_name, inputs, expected_directory)
    if Dir.exist?(expected_directory)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ディレクトリが存在済み)"
        return
    end
    auto_input(inputs)
    # 下記でテストが成功か否かを表示
    if Dir.exist?(expected_directory)
        puts "success #{test_name}".green
        # 状態のリセット(ディレクトリの削除)
        Dir.rmdir expected_directory
    else
        puts "fail #{test_name}".red
    end
end

def confirm_directory_delete(test_name, inputs, expected_directory)
    unless Dir.exist?(expected_directory)
        puts "fail #{test_name}".red
        puts "テストケースとして問題あり(ディレクトリが未存在)"
        return
    end
    copy_directory = "copy_dir"
    # ディレクトリの一時的なコピー
    FileUtils.cp_r expected_directory, copy_directory
    auto_input(inputs)
    # 下記でテストが成功か否かを表示
    # 変更する必要性あり
    if Dir.exist?(expected_directory)
        puts "fail #{test_name}".red
    else
        puts "success #{test_name}".green
    end
    # リセット
    unless Dir.exist?(expected_directory)
        FileUtils.cp_r copy_directory, expected_file
    end
    Dir.rmdir copy_directory
end


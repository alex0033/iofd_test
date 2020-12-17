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

def in_test_environment
    original_dir = Dir::pwd
    # コピーディレクトリ作成準備
    Dir::chdir ".."
    copy_dir = "#{Dir::pwd}/copy_dir"
    if Dir.exist? copy_dir || original_dir == copy_dir
        puts "テスト環境が準備できません"
        Dir::chdir original_dir
        return
    end
    # コピーディレクトリ作成と移動
    FileUtils.cp_r original_dir, copy_dir
    Dir::chdir copy_dir
    # 下記でtestを実施
    begin
        yield
    rescue => error
        puts error
    end
    # 状態のリセット
    Dir::chdir ".."
    FileUtils.rm_rf copy_dir
    Dir::chdir original_dir
end

def test_error(test_name, message = nil)
    puts "fail #{test_name}".red
    puts "**#{message}" if message
    return
end

def it(test_name, inputs, outputs: [], files: [], directories: [], remove_files: [], remove_directories: [])
    has_error = false
    in_test_environment do
        auto_input(inputs) do |i, o|
            begin
                # 完璧でない一致でOK問題
                # 例）"output"を期待したとき、"out"でもテストが通るという問題
                # この仕様だと細かい文字列のテストには問題あり
                outputs.each do |output|
                    i.expect(output)
                end
            rescue => error
                test_error test_name, error
                has_error = true
                # 出力結果を表示
                # flag???
            end
        end
        # filesの存在確認ー＞存在しないとエラーになる
        files.each do |f|
            unless File.exist?(f)
                test_error test_name
                has_error = true
            end
        end
        # directoriesの存在確認ー＞存在しないとエラーになる
        directories.each do |d|
            unless Dir.exist?(d)
                test_error test_name
                has_error = true
            end
        end
        # remove_filesの存在確認ー＞存在するとエラーになる
        remove_files.each do |f|
            if File.exist?(f)
                test_error test_name
                has_error = true
            end
        end
        # remove_directoriesの存在確認ー＞存在するとエラーになる
        remove_directories.each do |d|
            if Dir.exist?(d)
                test_error test_name, "#{d}が削除できていません"
                has_error = true
            end
        end
        # 最後までたどり着けば成功
        puts "success #{test_name}".green unless has_error
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

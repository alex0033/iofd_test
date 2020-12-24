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

def auto_io(io_contents)
    PTY.getpty(@cmd) do |i, o, pid|
        io_contents.each do |content|
            i.expect(content[:output]) do |line|
                puts line.inspect
                if content[:input]
                    o.puts content[:input]
                    i.expect content[:input]
                end
            end
        end
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
        puts "come error"
    end
    # 状態のリセット
    Dir::chdir ".."
    FileUtils.rm_rf copy_dir
    Dir::chdir original_dir
end

def test_error(test_name, messages = [])
    puts "fail #{test_name}".red
    messages.each do |message|
        puts "**#{message}"
    end
end

def it_io(test_name, io_contents, files: [], directories: [], remove_files: [], remove_directories: [])
    # 引数の型チェックを行う必要性？？
    error_contents = Array.new
    in_test_environment do
        # 最後までたどり着けば成功
        begin
            auto_io(io_contents)
        rescue => error
            error_contents.push error
        end
        # filesの存在確認、内容一致の確認ー＞存在しないとエラーになる
        files.each do |f|
            if !File.exist?(f[:original])
                error_contents.push "#{f[:original]}が存在しません"
            elsif f[:comparison] && File.exist?(f[:comparison]) && !FileUtils.cmp(f[:original], f[:comparison])
                error_contents.push "#{f[:comparison]}と内容が一致しません"
            end
        end
        # directoriesの存在確認ー＞存在しないとエラーになる
        directories.each do |d|
            unless Dir.exist?(d)
                error_contents.push "#{d}が存在しません"
            end
        end
        # remove_filesの存在確認ー＞存在するとエラーになる
        remove_files.each do |f|
            if File.exist?(f)
                error_contents.push "#{f}が削除できていません"
            end
        end
        # remove_directoriesの存在確認ー＞存在するとエラーになる
        remove_directories.each do |d|
            if Dir.exist?(d)
                error_contents.push "#{d}が削除できていません"
            end
        end
        # 最後までたどり着けば成功
        if error_contents.any?
            test_error test_name, error_contents
        else
            puts "success #{test_name}".green
        end
    end
end

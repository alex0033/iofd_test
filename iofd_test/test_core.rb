require 'pty'
require 'expect'
require 'fileutils'
require './iofd_test/iofd_class.rb'

def set_cmd(file_name)
    Iofd.set_command("ruby #{file_name}")
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

def iofd(test_name)
    iofd = Iofd.new test_name
    iofd = yield iofd
    in_test_environment do
        iofd.exec_test
    end
end

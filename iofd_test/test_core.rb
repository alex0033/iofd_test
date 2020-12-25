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

def in_test_environment(iofd)
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
    # テストデータの作成
    iofd.test_data[:directories].each do |d|
        Dir.exist?(d) ? iofd.error_contents.push("ディレクトリのデータエラー") : Dir.mkdir(d)
    end
    iofd.test_data[:files].each do |f|
        File.exist?(f) ? iofd.error_contents.push("ファイルのデータエラー") : File.open(f)
    end
    # 下記でtestを実施
    begin
        iofd.test_error? ? iofd.test_error : yield
    rescue => error
        iofd.error_contents.push error
        iofd.test_error
    end
    # テストデータの削除
    iofd.test_data[:files].each do |f|
        File.delete f if File.exist? f
    end
    iofd.test_data[:directories].each do |d|
        FileUtils.rm_rf d if Dir.exist? d
    end
    # 状態のリセット
    Dir::chdir ".."
    FileUtils.rm_rf copy_dir
    Dir::chdir original_dir
end

def iofd(test_name)
    puts "始--------始"
    iofd = Iofd.new test_name
    iofd = yield iofd
    in_test_environment(iofd) do
        iofd.exec_test
    end
    puts "終--------終"
    puts
end

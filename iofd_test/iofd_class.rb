require 'pty'
require 'expect'
require 'fileutils'

class Iofd
    attr_accessor :io_contents, :files, :remove_files,
                  :directories, :remove_directories,
                  :test_name, :test_data

    def initialize(test_name)
        @test_name = test_name
        @io_contents = []
        @files = []
        @remove_files = []
        @directories = []
        @remove_directories = []
        @error_contents = []
        @test_data = { files: [], directories: [] }
    end

    def self.set_command(cmd)
        @@cmd = cmd
    end

    def exec_test
        io_contents_test
        files_test
        directories_test
        remove_files_test
        remove_directories_test
        # 最後までたどり着けば成功
        test_error? ? test_error : puts("success #{@test_name}".green)
    end

    def test_error
        puts "fail #{@test_name}".red
        @error_contents.each do |content|
            puts "**#{content}"
        end
    end

    def test_error?
        @error_contents.any?
    end

    private  

    def io_contents_test
        begin
            PTY.getpty(@@cmd) do |i, o, pid|
                @io_contents.each do |content|
                    i.expect(content[:output], 10) do |line|
                        # 以下二行で正確な文字列チェック
                        output = line[0].gsub(/[\n\r]/,"")
                        @error_contents.push "期待値：#{content[:output]} 実際：#{output}" unless output == content[:output]
                        # 下記if文の塊のおかげで
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
        rescue => error
            @error_contents.push error
        end
    end

    def files_test
        # filesの存在確認、内容一致の確認ー＞存在しない、内容不一致だとエラーになる
        @files.each do |f|
            if !File.exist?(f[:original])
                @error_contents.push "#{f[:original]}が存在しません"
            elsif f[:comparison] && File.exist?(f[:comparison]) && !FileUtils.cmp(f[:original], f[:comparison])
                @error_contents.push "#{f[:comparison]}と内容が一致しません"
            end
        end
    end

    def directories_test
        # directoriesの存在確認ー＞存在しないとエラーになる
        @directories.each do |d|
            unless Dir.exist?(d)
                @error_contents.push "#{d}が存在しません"
            end
        end
    end
    
    def remove_files_test
        # remove_filesの存在確認ー＞存在するとエラーになる
        @remove_files.each do |f|
            if File.exist?(f)
                @error_contents.push "#{f}が削除できていません"
            end
        end
    end

    def remove_directories_test
        # remove_directoriesの存在確認ー＞存在するとエラーになる
        @remove_directories.each do |d|
            if Dir.exist?(d)
                @error_contents.push "#{d}が削除できていません"
            end
        end
    end
end

require 'pty'
require 'expect'

@exec_file = "sample.rb"
# exec_file = ARGV[0]

class String
    # colorization
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
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
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

def confirm_file_exist(test_name, inputs, expected_file)
    cmd = "ruby #{@exec_file}"
    PTY.getpty(cmd) do |i, o|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
    end
    # 下記でテストが成功か否かを表示
    if File.exist?(expected_file)
        puts "success #{test_name}".green
    else
        puts "fail #{test_name}".red
    end
end

def confirm_file_output(test_name, inputs, expected_file, output_file_for_test)
    cmd = "ruby #{@exec_file}"
    PTY.getpty(cmd) do |i, o|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
    end
    # 下記でテストが成功か否かを表示
    if File.exist?(expected_file)
        puts "success #{test_name}".green
    else
        puts "fail #{test_name}".red
    end
end


def confirm_directory_exist(test_name, inputs, expected_directory)
    cmd = "ruby #{@exec_file}"
    PTY.getpty(cmd) do |i, o|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
    end
    # 下記でテストが成功か否かを表示
    if Dir.exist?(expected_directory)
        puts "success #{test_name}".green
    else
        puts "fail #{test_name}".red
    end
end

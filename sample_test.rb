require 'pty'
require 'expect'

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

def console_test(test_name, inputs, expected_output)
    cmd = "ruby sample.rb"
    flag = false
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

def file_test(test_name, inputs, expected_file)
    cmd = "ruby sample.rb"
    PTY.getpty(cmd) do |i, o|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
        # 下記でテストが成功か否かを表示
        if File.exist?(expected_file)
            puts "success #{test_name}".green
        else
            puts "fail #{test_name}".red
        end
    end
end

def directory_test(test_name, inputs, expected_directory)
    cmd = "ruby sample.rb"
    PTY.getpty(cmd) do |i, o|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
        # 下記でテストが成功か否かを表示
        if Dir.exist?(expected_directory)
            puts "success #{test_name}".green
        else
            puts "fail #{test_name}".red
        end
    end
end


inputs1 = [
    { assist_input: "a:", auto_input: "2" },
    { assist_input: "b:", auto_input: "3" }
]
expected_output1 = "a+b: 5"

inputs2 = [
    { assist_input: "a:", auto_input: "5" },
    { assist_input: "b:", auto_input: "7" }
]
expected_output2 = "a+b: 10"

console_test("test1", inputs1, expected_output1)
console_test("test2", inputs2, expected_output2)

file_test("file", inputs1, "/home/alex/desktop/my_rb_test/sample.rb")
directory_test("directory", inputs2, "/home/alex/desktop/my_rb_test")
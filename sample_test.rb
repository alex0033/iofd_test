require 'pty'
require 'expect'

def console_test(test_name, inputs, expected_output)
    cmd = "ruby sample.rb"
    PTY.getpty(cmd) do |i, o|
        inputs.each do |input|
            i.expect(input[:assist_input], 10) do
                o.puts input[:auto_input]
            end
        end
        # 下記でテストが成功か否かを表示
        begin
            i.expect(expected_output, 10) do |line|
                puts "success #{test_name}"
            end
        rescue => error
            puts "fail #{test_name}"
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
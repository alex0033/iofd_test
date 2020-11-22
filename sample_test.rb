require './test_core.rb'

inputs1 = [
    { assist_input: "action:", auto_input: "plus" },
    { assist_input: "a:", auto_input: "2" },
    { assist_input: "b:", auto_input: "3" },
]
expected_output1 = "a+b: 5"
cofirm_console_output("test1", inputs1, expected_output1)

inputs2 = [
    { assist_input: "action:", auto_input: "plus" },
    { assist_input: "a:", auto_input: "5" },
    { assist_input: "b:", auto_input: "-6" }
]
expected_output2 = "a+b: -1"
cofirm_console_output("test2", inputs2, expected_output2)

confirm_file_exist("file", inputs1, "/home/alex/desktop/my_rb_test/sample.rb")
confirm_directory_exist("directory", inputs2, "/home/alex/desktop/my_rb_test")
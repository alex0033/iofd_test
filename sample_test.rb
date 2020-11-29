require './test_core.rb'

inputs1 = [
    { assist_input: "action: ", auto_input: "plus" },
    { assist_input: "a: ", auto_input: "2" },
    { assist_input: "b: ", auto_input: "3" },
]
expected_output1 = "a+b: 5"
cofirm_console_output("test1", inputs1, expected_output1)

inputs2 = [
    { assist_input: "action: ", auto_input: "plus" },
    { assist_input: "a: ", auto_input: "5" },
    { assist_input: "b: ", auto_input: "-6" }
]
expected_output2 = "a+b: -1"
cofirm_console_output("test2", inputs2, expected_output2)

test_file = "output_files/test_file.output"
file_inputs = [
    { assist_input: "action: ", auto_input: "mkfile" },
    { assist_input: "file name: ", auto_input: "test_file" },
]
confirm_file_create("file_exist", file_inputs, test_file)

confirm_new_file("new_file_eq", file_inputs, test_file, "comparison_files/new_file.txt")

chfile_inputs = [
    { assist_input: "action: ", auto_input: "chfile" },
    { assist_input: "change: ", auto_input: "change" },
]
confirm_changed_file("change_file_eq", chfile_inputs, "change_file", "comparison_files/change_file.txt")

rmfile_inputs = [
    { assist_input: "action: ", auto_input: "rmfile" },
    { assist_input: "remove file: ", auto_input: "remove_file" },
]
confirm_delete_file("remove_file", rmfile_inputs, "remove_file")

test_dir = "test_dir"
directory_inputs = [
    { assist_input: "action:", auto_input: "mkdir" },
    { assist_input: "directory name:", auto_input: test_dir }
]
confirm_directory_exist("directory_exist", directory_inputs, test_dir)

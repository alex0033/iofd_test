require './iofd_test/test_core.rb'

set_cmd "sample.rb"

inputs2 = [
    { output: "action: ", input: "plus" },
    { output: "a: ", input: "5" },
    { output: "b: ", input: "-6" },
    { output: "a+b: -1", input: nil }
]
it_io("test2", inputs2)

test_file = "output_files/test_file.output"
file_inputs = [
    { output: "action: ", input: "mkfile" },
    { output: "file name: ", input: "test_file" },
]
files = [
    { original: test_file, comparison: "iofd_test/comparison_files/new_file.txt" }
]
it_io("file_exist", file_inputs, files: files)

chfile_inputs = [
    { output: "action: ", input: "chfile" },
    { output: "change: ", input: "change" },
]
files = [
    { original: "change_file", comparison: "iofd_test/comparison_files/change_file.txt" }
]
it_io("change_file_eq", chfile_inputs, files: files)

rmfile_inputs = [
    { output: "action: ", input: "rmfile" },
    { output: "remove file: ", input: "remove_file" },
]
it_io("remove_file", rmfile_inputs, remove_files: ["remove_file"])

test_dir = "test_dir"
directory_inputs = [
    { output: "action:", input: "mkdir" },
    { output: "directory name:", input: test_dir }
]
it_io("create_directory", directory_inputs, directories: [test_dir])

remove_dir = "remove_directory"
directory_inputs = [
    { output: "action:", input: "rmdir" },
    { output: "directory name:", input: remove_dir }
]
it_io("remove_directory", directory_inputs, remove_directories: [remove_dir])

outputs_inputs = [
    { output: "action: ", input: "outputs" },
    { output: "good", input: nil },
    { output: "good", input: nil }
]
it_io("outputs", outputs_inputs)

io_inputs = [
    { output: "action: ", input: "io" },
    { output: "input: ", input: "st" },
    { output: "st", input: nil },
    { output: "st", input: nil },
    { output: "input again: ", input: "st2" },
    { output: "st2", input: nil },
    { output: "st2", input: nil }
]
it_io("io_test", io_inputs)

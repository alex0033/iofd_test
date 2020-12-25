require './iofd_test/test_core.rb'

set_cmd "sample.rb"

iofd "test" do |iofd|
    iofd.io_contents = [
        { output: "what action: ", input: "plus" },
        { output: "a: ", input: "5" },
        { output: "b: ", input: "-6" },
        { output: "a+b: -1", input: nil }
    ]
    iofd
end

iofd "new_file_eq" do |iofd|
    test_file = "output_files/test_file.output"
    iofd.io_contents = [
        { output: "what action: ", input: "mkfile" },
        { output: "file name: ", input: "test_file" },
    ]
    iofd.files = [
        { original: test_file, comparison: "iofd_test/comparison_files/new_file.txt" }
    ]
    iofd
end

iofd "change_file_eq" do |iofd|
    iofd.io_contents = [
        { output: "what action: ", input: "chfile" },
        { output: "change: ", input: "change" },
    ]
    iofd.files = [
        { original: "change_file", comparison: "iofd_test/comparison_files/change_file.txt" }
    ]
    iofd
end

iofd "remove_file" do |iofd|
    iofd.io_contents = [
        { output: "what action: ", input: "rmfile" },
        { output: "remove file: ", input: "remove_file" },
    ]
    iofd.remove_files = ["remove_file"]
    iofd
end

iofd "create_directory" do |iofd|
    test_dir = "test_dir"
    iofd.io_contents = [
        { output: "what action: ", input: "mkdir" },
        { output: "directory name: ", input: test_dir }
    ]
    iofd.directories = [test_dir]
    iofd
end

iofd "remove_directory" do |iofd|
    remove_dir = "remove_directory"
    iofd.io_contents = [
        { output: "what action: ", input: "rmdir" },
        { output: "directory name: ", input: remove_dir }
    ]
    iofd.remove_directories = [remove_dir]
    iofd
end

iofd "outputs" do |iofd|
    iofd.io_contents = [
        { output: "what action: ", input: "outputs" },
        { output: "good", input: nil },
        { output: "good", input: nil }
    ]
    iofd
end

iofd "io_test" do |iofd|
    iofd.io_contents = [
        { output: "what action: ", input: "io" },
        { output: "input: ", input: "st" },
        { output: "st", input: nil },
        { output: "st", input: nil },
        { output: "input again: ", input: "st2" },
        { output: "st2", input: nil },
        { output: "st2", input: nil }
    ]
    iofd
end

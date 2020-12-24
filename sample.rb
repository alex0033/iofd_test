def plus
    print "a: "
    a = gets.chomp.to_i
    print "b: "
    b = gets.chomp.to_i
    puts "a+b: #{a + b}"
end

def mkfile
    print "file name: "
    file_name = gets.chomp
    output = "aaa\nbbb"
    File.open("output_files/#{file_name}.output", "w") do |f|
        f.puts output
    end
end

def chfile
    print "change: "
    output = gets.chomp
    File.open("change_file", "w") do |f|
        f.puts output
    end
end

def rmfile
    print:"remove file: "
    file_name = gets.chomp
    File.delete file_name
end

def mkdir
    print "directory name: "
    directory_name = gets.chomp
    Dir.mkdir directory_name unless Dir.exist? directory_name
end

def rmdir
    print "directory name: "
    directory_name = gets.chomp
    Dir.rmdir directory_name if Dir.exist? directory_name
end

def outputs
    puts "good"
    puts "good"
end

def io
    print "input: "
    st = gets.chomp
    puts st
    puts st
    print "input again: "
    st = gets.chomp
    puts st
    puts st
end

print "what action: "
action = gets.chomp

case action
when "plus"
    plus
when "mkfile"
    mkfile
when "chfile"
    chfile
when "rmfile"
    rmfile
when "mkdir"
    mkdir
when "rmdir"
    rmdir
when "outputs"
    outputs
when "io"
    io
else
    puts "That action is nothing."
end

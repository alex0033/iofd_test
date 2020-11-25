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

def mkdir
    print "directory name: "
    directory_name = gets.chomp
    Dir.mkdir directory_name unless Dir.exist? directory_name
end

print "what action: "
action = gets.chomp

case action
when "plus"
    plus
when "mkfile"
    mkfile
when "mkdir"
    mkdir
else
    puts "That action is nothing."
end

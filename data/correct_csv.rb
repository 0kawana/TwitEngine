
filename = ARGV[0]

if filename.nil?
    puts "error"
    exit
end

File.open("#{filename}.csv", "w") do |file|
    f = File.read("#{filename}_drive.txt")
    f.split("\n").each do |line|
        file.puts line.gsub(/\s+/, ",")
    end
end


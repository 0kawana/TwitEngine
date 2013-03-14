
File.open("pattern.csv", "w") do |file|
    f = File.read("pattern_drive.txt")
    f.split("\n").each do |line|
        file.puts line.gsub(/\s+/, ",")
    end
end





File.open("response.csv", "w") do |file|
    f = File.read("response_drive.txt")
    f.split("\n").each do |line|
        file.puts line.gsub(/\s+/, ",")
    end
end


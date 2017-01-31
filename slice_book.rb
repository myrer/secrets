fin = File.open("ti.txt", "r")

i = 0
file_number = 1
max_lines = 50
text = ""
while line = fin.gets
	i += 1
	text << line
	if i == max_lines
		fout = File.open("clear/f#{file_number}.txt","w")
		fout.write(text)
		fout.close
		i = 0
		text = ""
		file_number += 1
	end
end

fin.close
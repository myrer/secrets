def g_caesar_encryption_maps(encryption_key = 0)
	alphabet = ('A'..'Z').to_a + ('a'..'z').to_a 
	encryption_map = {}
	decrypt_map = {}
	alphabet.each_with_index do |letter, index| 
		cypher_index = (index + encryption_key).modulo(alphabet.size)
		cypher_letter = alphabet[cypher_index]
		encryption_map[letter] = cypher_letter
		decrypt_map[cypher_letter] = letter
	end
	return encryption_map, decrypt_map
end

def encrypt_caesar(text, encryption_key = 0)
	encryption_map, decrypt_map = g_caesar_encryption_maps(encryption_key)
	cypher_text = ""
	text.size.times do |i|
		letter = text[i]
		if encryption_map.has_key?(letter)
			cypher_text << encryption_map[letter]
		else
			cypher_text << letter
		end
	end	
	return cypher_text
end

def decrypt_caesar(cypher_text, encryption_key = 0)
	encryption_map, decrypt_map = g_caesar_encryption_maps(encryption_key)
	text = ""
	cypher_text.size.times do |i|
		cypher = cypher_text[i]
		if decrypt_map.has_key?(cypher)
			text << decrypt_map[cypher]
		else
			text << cypher
		end
	end	
	return text
end

def encrypt_files
	fmaster = File.open("/home/rick/rbf/master_01.txt", "w")
	num_files = 155
	num_files.times do |file_number|
		
		#Read clear text to encrypt
		file_name = "clear/f#{file_number+1}.txt"
		f = File.open(file_name,"r")
		text = ""
		while line = f.gets
			text << line
		end
		f.close
		
		#Encrypt text with random encryption key
		encryption_key = rand(100)
		cypher_text = encrypt_caesar(text, encryption_key)
		
		#Write encrypted text
		fout = File.open("secrets/f#{file_number+1}.txt","w")
		fout.write(cypher_text)
		fout.close
		
		#Record encryption key associated with each file
		cypher_text
		fmaster.write("#{Time.now}\t#{file_name}\t#{encryption_key}\n")
	end	
	fmaster.close
end	


def decrypt_files_with_master
	fmaster = File.open("/home/rick/rbf/master_01.txt", "r")
	num_files = 155
	num_files.times do |file_number|
		
		#Read cypher_text to decrypt
		file_name = "secrets/f#{file_number+1}.txt"
		f = File.open(file_name,"r")
		cypher_text = ""
		while line = f.gets
			cypher_text << line
		end
		f.close
		
		#Decrypt cypher_text with encryption key
		line = fmaster.gets
		time, name, encryption_key = line.split("\t")
		text = decrypt_caesar(cypher_text, encryption_key.to_i)
		
		#Write decrypted text
		fout = File.open("decrypt/f#{file_number+1}.txt","w")
		fout.write(text)
		fout.close
	end	
	fmaster.close
end	

def decrypt_files(word_list, pcent = 50)
	num_files = 155
	num_files.times do |file_number|
		
		#Read cypher_text to decrypt
		file_name = "secrets/f#{file_number+1}.txt"
		text = decrypt_file(file_name, word_list, pcent)
		puts text
	end	
end	



def g_english_word_list(file_name)
	word_list = {}
	
	f = File.open(file_name,"r")
	while word = f.gets
		word = word.gsub("\n", "")
		word_list[word.chomp] = 1;
	end	
	f.close
	return word_list
end

def is_intelligible?(word_list, text, pcent)
	text = text.gsub(/[,;.!?"'&%$;:-]/, " ")
	words = text.split(" ").collect{|x| x.strip}
	
	num_words = words.size
	good_words = 0
	words.each do |word| 
		good_words += 1 if word_list.has_key?(word.downcase)
	end	
	score = good_words.to_f/num_words.to_f*100.0
	rv =  score >= pcent.to_f
	#~ puts "#{good_words} #{num_words} #{score} #{rv}"
	return rv
end

def decrypt_file(file_name, word_list, pcent = 50)
	#Read encrypted file
	f = File.open(file_name,"r")
	cypher_text = ""
	while line = f.gets
		cypher_text << line
	end
	f.close
		
	#Try to decrypt cypher_text with encryption key
	encryption_key = 0
	done = false
	pcent = 20
	while !done do
		text = decrypt_caesar(cypher_text, encryption_key)
		
		if is_intelligible?(word_list, text, pcent)
			done = true
		else
			encryption_key += 1	
			done = true if encryption_key == 1000
			text = "Cannot decrypt!"
		end	
	end
	
	return text
end	

#-----
english_word_list = g_english_word_list('dict/ukenglish.txt')

#~ decrypt_file('secrets/f1.txt')
#~ file_name = "secrets/f102.txt"
#~ f = File.open(file_name,"r")
#~ cypher_text = ""
#~ while line = f.gets
	#~ cypher_text << line
#~ end
#~ f.close

decrypt_files(english_word_list, 50)

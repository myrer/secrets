def g_caesar_encryption_map(encryption_key = 0)
	alphabet = ('A'..'Z').to_a + ('a'..'z').to_a 
	encryption_map = {}
	alphabet.each_with_index do |letter, index| 
		cypher_index = (index + encryption_key).modulo(alphabet.size)
		cypher_letter = alphabet[cypher_index]
		encryption_map[letter] = cypher_letter
		#~ puts "#{letter} \t #{index} \t #{cypher_letter}"
	end
	return encryption_map
end

def encrypt_caesar(text, encryption_key = 0)
	encryption_map = g_caesar_encryption_map(encryption_key)
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

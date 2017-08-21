def generer_encodeur(cle_encodage = 0)
	# Cette méthode produit un Hash qui associe une lettre 'en clair' (A à Z ) à une lettre encodée selon la clé d'encodage.
	# Exemple 1  : cle_encodage = 1 
	# A => B, B => C, C => D, ..., X => Y, Y=> Z, Z => A.
	#
	# Exemple 2  : cle_encodage = 2 
	# A => C, B => D, C => E, ..., X => Z, Y=> A, Z => B.
	#
	
	alphabet = ('A'..'Z').to_a #On crée un Array nommé 'alphabet' qui contient 26 éléments String : "A", "B", ..., "Z".
	encodeur = {} # On crée un Hash vide qui se nomme 'encodeur'.
	
	#Parcourir chaque élément du Array 'alphabet' que l'on nomme 'lettre'. 
	# La variable  'index' correpond à la position de chaque élément du Array 'alphabet' :
	# alphabet[0] = "A"
	# alphabet[1] = "B"
	# alphabet[2] = "C"
	#...
	# alphabet[26] = "Z"
	
	alphabet.each_with_index do |lettre, index|
		index_encodage = (index + cle_encodage).modulo(alphabet.size)  #Pourquoi modulo? pensez-y!
		lettre_encodee = alphabet[index_encodage]
		encodeur[lettre] = lettre_encodee
	end
	return encodeur
end

def generer_decodeur(cle_encodage = 0)
	# Cette méthode produit un hash qui associe une lettre encodée à une lettre 'en clair' selon la clé d'encodage.
	# Exemple 1  : cle_encodage = 1 
	# A => B, B => C, C => D, ..., X => Y, Y=> Z, Z => A.
	#
	# Exemple 2  : cle_encodage = 2 
	# A => C, B => D, C => E, ..., X => Z, Y=> A, Z => B.
	#
	
	alphabet = ('A'..'Z').to_a #On crée un Array nommé 'alphabet' qui contient 26 éléments String : "A", "B", ..., "Z".
	decodeur = {} # On crée un Hash vide qui se nomme 'decodeur'.
	
	#Parcourir chaque élément du Array 'alphabet' que l'on nomme 'lettre'. 
	# La variable  'index' correpond à la position de chaque élément du Array 'alphabet' :
	# alphabet[0] = "A"
	# alphabet[1] = "B"
	# alphabet[2] = "C"
	#...
	# alphabet[26] = "Z"
	
	alphabet.each_with_index do |lettre, index|
		index_encodage = (index + cle_encodage).modulo(alphabet.size)  #Pourquoi modulo? pensez-y!
		lettre_encodee = alphabet[index_encodage]
		decodeur[lettre_encodee] = lettre
	end
	return decodeur
end

def encoder_texte(texte_en_clair, encodeur)
	texte_encode = ""
	texte_en_clair.size.times do |i|
		lettre = texte_en_clair[i].upcase #Mettre en majuscules
		if encodeur.has_key?(lettre)
			texte_encode << encodeur[lettre]
		else
			texte_encode << lettre
		end
	end	
	return texte_encode
end

def decoder_texte(texte_encode, decodeur)
	texte_en_clair = ""
	texte_encode.size.times do |i|
		lettre = texte_encode[i].upcase #Mettre en majuscules
		if decodeur.has_key?(lettre)
			texte_en_clair << decodeur[lettre]
		else
			texte_en_clair << lettre
		end
	end	
	return texte_en_clair
end


def generer_dictionnaire_anglais(nom_fichier)
	dictionnaire = {}
	
	f = File.open(nom_fichier,"r")
	while mot = f.gets
		mot = mot.chomp
		dictionnaire[mot] = 1;
	end	
	f.close
	return dictionnaire
end

def intelligible?(dictionnaire, texte, pcent)
	texte = texte.gsub(/[,;.!?"'&%$;:-]/, " ")
	mots = texte.split(" ").collect{|x| x.strip}
	
	nombre_mots = mots.size
	nombre_mots_dans_le_dictionnaire = 0
	mots.each do |mot| 
		nombre_mots_dans_le_dictionnaire += 1 if dictionnaire.has_key?(mot.downcase)
	end	
	score = nombre_mots_dans_le_dictionnaire*100 / nombre_mots #À discuter!
	valeur =  score >= pcent
	return valeur
end

def decoder_fichier(nom_fichier, dictionnaire, pcent = 50)
	#Lire fichier encodé
	f = File.open(nom_fichier,"r")
	texte_encode = ""
	while ligne= f.gets
		texte_encode << ligne
	end
	f.close
		
	#Décodons avec la clé d'encodage 0
	cle_encodage = 0
	fini = false
	pcent = 20
	while !fini do
		decodeur = generer_decodeur(cle_encodage)
		texte_en_clair = decoder_texte(texte_encode, decodeur)
		
		if intelligible?(dictionnaire, texte_en_clair, pcent)
			fini = true
		else
			cle_encodage = cle_encodage + 1	#Passons à la clé d'encodage suivante et répétons
			fini = true if cle_encodage == 26
			texte_en_clair = "ZUT!!! Pas capabable de décoder ... Grrrrrr!!!!"
		end	
	end
	#~ puts cle_encodage # Afficher la clé d'encodage
	return texte_en_clair
end	



#----EXEMPLE 1
puts "Exemple 1"
cle_encodage = 1 #Essayez vous-même en modifiant la clé d'encodage
encodeur = generer_encodeur(cle_encodage)
decodeur = generer_decodeur(cle_encodage)

texte_initial = "Bonjour Gabriel!" #Essayez vous-même en modifiant le texte 
texte_encode = encoder_texte(texte_initial, encodeur)
puts texte_encode

texte_en_clair = decoder_texte(texte_encode, decodeur)
puts texte_en_clair

puts "-"*50
puts "Exemple 2"
dictionnaire = generer_dictionnaire_anglais("dict/ukenglish.txt")
puts decoder_fichier('secrets/f50.txt', dictionnaire)
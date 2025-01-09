
# Charger les bibliothèques nécessaires
library(rvest)
library(dplyr)
library(text2vec)
library(lsa)
library(readr)


#Fonction pour prendre les informations sur le top 300 des séries sur allocine 
grab_info = function(){
  series_info = c()
  for (number_of_page in c(1:20)) {
    link= paste0("https://www.allocine.fr/series/meilleures/?page=", number_of_page )
    page_content = read_html(link)
    links_of_pages = page_content %>% html_nodes('.entity-card-list .meta-title-link') %>%
      html_attr("href") %>% paste("https://www.allocine.fr", .,sep = "")
    for (serie_page in links_of_pages){
      page_content = read_html(serie_page)
      serie_name = page_content %>% html_nodes('.titlebar-title-xl .titlebar-link')%>% html_text()
      serie_synopsis = page_content %>% html_nodes('.bo-p:nth-child(1)')%>% html_text()
      if (length(serie_synopsis)==0) {
        serie_synopsis = NA}
      serie_info = cbind(serie_name,serie_synopsis)
      series_info = rbind(series_info,serie_info)
    }
  }
  series_info_df = as.data.frame(series_info)
  return(series_info_df)
}



# Appeler la fonction pour récupérer les données
data <- grab_info()
all_synopsis <- data$serie_synopsis

# Fonction pour entraîner le modèle GloVe et calculer les similarités
model_with_train <- function(all_synopsis) {
  prep_fun <- tolower 
  tok_fun <- word_tokenizer  
  
  # Préparation des données
  tokens <- all_synopsis %>%
    prep_fun() %>%
    tok_fun()
  it <- itoken(tokens, ids = seq_along(all_synopsis), progressbar = FALSE)
  
  # Création du vocabulaire et du modèle
  vocab <- create_vocabulary(it)
  vectorizer <- vocab_vectorizer(vocab)
  tcm <- create_tcm(it, vectorizer, skip_grams_window = 5)
  glove_model <- GlobalVectors$new(rank = 50, x_max = 10)
  word_vectors <- glove_model$fit_transform(tcm, n_iter = 20)
  word_vectors <- word_vectors + t(glove_model$components)
  
  # Fonction pour obtenir un vecteur de texte
  get_text_vector <- function(text, word_vectors) {
    words <- unlist(word_tokenizer(tolower(text)))  # Tokenisation des mots
    words <- words[words %in% rownames(word_vectors)]  # Filtrer les mots connus
    if (length(words) == 0) {
      return(rep(0, ncol(word_vectors)))  # Vecteur nul si aucun mot connu
    }
    word_vecs <- word_vectors[words, , drop = FALSE]
    colMeans(word_vecs)  # Moyenne des vecteurs des mots
  }
  
  # Calcul des vecteurs de synopsis
  synopsis_vectors <- t(sapply(all_synopsis, get_text_vector, word_vectors = word_vectors))
  similarity_matrix <- cosine(t(synopsis_vectors))
  
  return(similarity_matrix)
}

# Calculer la matrice de similarité
similarity_matrix <- model_with_train(all_synopsis)

# Fonction pour trouver les séries similaires
find_similar_series <- function(input_series, data, similarity_matrix, top_n = 3) {
  # Vérifier si la série d'entrée existe dans les données
  if (!input_series %in% data$serie_name) {
    stop("La série entrée n'existe pas dans les données.")
  }
  
  # Obtenir l'index de la série d'entrée
  input_index <- which(data$serie_name == input_series)
  
  # Extraire les similarités pour la série d'entrée
  series_similarities <- similarity_matrix[input_index, ]
  
  # Convertir en data frame pour faciliter le tri
  similarity_df <- data.frame(
    serie_name = data$serie_name,
    similarity_score = series_similarities
  )
  
  # Filtrer la série d'entrée elle-même et trier par score de similarité
  top_similar <- similarity_df %>%
    filter(serie_name != input_series) %>%
    arrange(desc(similarity_score)) %>%
    head(top_n)
  
  return(top_similar)
}

# Exemple d'utilisation
input_series <- "Breaking Bad"  # Remplacez par le nom de votre série
find_similar_series(input_series, data, similarity_matrix)








#Voici le code pour scraper toutes les séries et leurs synopsis (environ 9 heures d'éxecution)

#grab_info <- function() {
#  series_info <- c()
  
  # Parcourir les pages du site Allociné
#  for (number_of_page in 1:1434) {
#    link <- paste0("https://www.allocine.fr/series-tv/?page=", number_of_page)
#   page_content <- read_html(link)
    
    # Extraire les liens vers chaque série
#    links_of_pages <- page_content %>% 
#      html_nodes('.entity-card-list .meta-title-link') %>% 
#      html_attr("href") %>% 
#     paste("https://www.allocine.fr", ., sep = "")
    
    # Extraire les noms et synopsis des séries
#    for (serie_page in links_of_pages) {
#     page_content <- read_html(serie_page)
#      serie_name <- page_content %>% 
#        html_nodes('.titlebar-title-xl .titlebar-link') %>% 
#        html_text()
#      serie_synopsis <- page_content %>% 
#        html_nodes('.bo-p:nth-child(1)') %>% 
#        html_text()
      
#      if (length(serie_synopsis) == 0) {
#        serie_synopsis <- NA
#      }
      
#      serie_info <- cbind(serie_name, serie_synopsis)
#      series_info <- rbind(series_info, serie_info)
#    }
#  }
  
  # Convertir les informations en DataFrame
#  series_info_df <- as.data.frame(series_info)
#  colnames(series_info_df) <- c("serie_name", "serie_synopsis")
#  return(series_info_df)
#}

# Appeler la fonction pour récupérer les données
#data <- grab_info()




data = read_csv("C:/Users/hassan/Desktop/econometrie/TechniquedeprogM1/toutsurserie.csv")

# Fonction pour charger les vecteurs FastText
read_fasttext <- function(path) {
  con <- gzfile(path, "rt")
  
  # Lire le header
  header <- readLines(con, n = 1)
  header_info <- strsplit(header, " ")[[1]]
  num_words <- as.integer(header_info[1])
  num_dimensions <- as.integer(header_info[2])
  
  # Préparer les listes pour stocker les vecteurs
  word_list <- character(num_words)
  vector_list <- matrix(0, nrow = num_words, ncol = num_dimensions)
  
  for (i in 1:num_words) {
    line <- readLines(con, n = 1)
    if (length(line) == 0) break
    parts <- strsplit(line, " ")[[1]]
    word_list[i] <- parts[1]
    vector_list[i, ] <- as.numeric(parts[-1])
  }
  
  close(con)
  rownames(vector_list) <- word_list
  vector_list
}

# Charger les vecteurs FastText
fasttext_path <- "C:/Users/hassan/Downloads/cc.fr.300.vec.gz"
word_vectors <- read_fasttext(fasttext_path)

# Fonction pour calculer le vecteur d'un texte
get_text_vector <- function(text, word_vectors) {
  words <- unlist(strsplit(tolower(text), "\\s+"))
  valid_words <- words[words %in% rownames(word_vectors)]
  
  if (length(valid_words) == 0) {
    return(rep(0, ncol(word_vectors)))
  }
  
  vecs <- word_vectors[valid_words, , drop = FALSE]
  colMeans(vecs, na.rm = TRUE)
}

# Extraire les données des séries
all_synopsis <- data$serie_synopsis

# Calculer les vecteurs pour tous les synopsis
synopsis_vectors_raw <- t(sapply(all_synopsis, get_text_vector, word_vectors = word_vectors))

# Filtrer les vecteurs valides
valid_vectors <- apply(synopsis_vectors_raw, 1, function(x) !all(x == 0))
synopsis_vectors <- synopsis_vectors_raw[valid_vectors, , drop = FALSE]
valid_data <- data[valid_vectors, ]  # Garder uniquement les séries valides

# Calculer la matrice de similarité
cosine_similarity <- function(x) {
  x <- as.matrix(x)
  sim <- tcrossprod(x) / (sqrt(rowSums(x^2) %*% t(rowSums(x^2))))
  sim[is.na(sim)] <- 0
  simsimilarity_matrix <- cosine_similarity(synopsis_vectors)

# Fonction pour trouver les séries similaires
find_similar_series <- function(input_series, valid_data, similarity_matrix, top_n = 3) {
  # Vérifiez si la série d'entrée existe dans les données filtrées
  if (!input_series %in% valid_data$serie_name) {
    stop("La série entrée n'existe pas dans les données filtrées.")
  }
  
  # Obtenez l'index de la série d'entrée dans les données filtrées
  input_index <- which(valid_data$serie_name == input_series)
  
  # Extraire les similarités pour la série d'entrée
  series_similarities <- similarity_matrix[input_index, ]
  
  # Convertir en data frame pour trier
  similarity_df <- data.frame(
    serie_name = valid_data$serie_name,
    similarity_score = series_similarities
  )
  
  # Filtrer la série d'entrée elle-même et trier par score de similarité
  top_similar <- similarity_df %>%
    filter(serie_name != input_series) %>%
    arrange(desc(similarity_score)) %>%
    head(top_n)
  
  return(top_similar)
}

# Exemple d'utilisation
input_series <- "Bodyguard"  # Remplacez par une série présente dans les données
top_3_series <- find_similar_series(input_series, valid_data, similarity_matrix)
print(top_3_series)







Library(dplyr)
data = read_csv("chemin d'accès au csv toutsurserie")
all_synopsis_embeddings = as.matrix(read.csv("chemin d'accès vers le csv embeddings synopsis"))


# Fonction pour calculer la similarité cosinus
cosine_similarity = function(vec1, vec2) {
  sum(vec1 * vec2) / (sqrt(sum(vec1^2)) * sqrt(sum(vec2^2)))

# Fonction pour trouver les séries similaires
find_similar_series = function(input_series, data, embeddings, top_n = 3) {
  # Retirer les données manquantes de la base de données
  data = data %>% filter(!is.na(serie_synopsis))
  # Vérifiez si la série d'entrée existe dans les données
  if (!input_series %in% data$serie_name) {
    stop("La série entrée n'existe pas dans les données.")
  }
  
  # Obtenez l'index de la série d'entrée
  input_index = which(data$serie_name == input_series)
  
  # Embedding de la série d'entrée
  input_embedding = embeddings[input_index, ]
  
  # Calcul des similarités cosinus
  similarity_scores = apply(embeddings, 1, function(vec) cosine_similarity(input_embedding, vec))
  
  # Créez un data frame pour les scores de similarité
  similarity_df = data.frame(
    serie_name = data$serie_name,
    similarity_score = similarity_scores
  )
  
  # Filtrez la série d'entrée elle-même et triez par score
  top_similar = similarity_df %>%
    filter(serie_name != input_series) %>%
    arrange(desc(similarity_score)) %>%
    head(top_n)
  
  return(top_similar)
}

input_series = "La série choisit (écrit de manière exact)"
top_similar_series <- find_similar_series(input_series, data, all_synopsis_embeddings)

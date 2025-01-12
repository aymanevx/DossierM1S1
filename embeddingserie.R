# Fonction pour obtenir des embeddings en utilisant des lots
get_embeddings = function(texts, api_key, batch_size = 100) {
  embeddings = list()  # Liste pour stocker les embeddings
  
  # Diviser les textes en lots
  batches = split(texts, ceiling(seq_along(texts) / batch_size))
  
  for (batch in batches) {
    # Créez le corps de la requête en JSON
    body = list(
      model = "text-embedding-ada-002",
      input = batch
    )
    
    # Envoyez la requête POST à l'API
    response = POST(
      url = "https://api.openai.com/v1/embeddings",
      add_headers(
        Authorization = paste("Bearer", api_key),
        Content-Type = "application/json"
      ),
      body = toJSON(body, auto_unbox = TRUE)
    )
    
    # Vérifiez le statut de la réponse
    if (status_code(response) == 200) {
      # Analysez la réponse JSON
      response_content = content(response, "text", encoding = "UTF-8")
      content_json = fromJSON(response_content, simplifyVector = FALSE)
      
      # Ajoutez les embeddings du lot
      for (item in content_json$data) {
        embeddings = append(embeddings, list(as.numeric(item$embedding)))
      }
    } else {
      # Affichez une erreur en cas de problème
      response_error = content(response, "text", encoding = "UTF-8")
      stop("Erreur lors de l'appel à l'API OpenAI : ", response_error)
    }
  }
  
  # Combinez tous les embeddings dans une matrice numérique
  embeddings_matrix = do.call(rbind, embeddings)
  return(embeddings_matrix)
}
api_key = "Votre clés Open AI"
all_synopsis_embeddings = get_embeddings(data$serie_synopsis, api_key, batch_size = 100)

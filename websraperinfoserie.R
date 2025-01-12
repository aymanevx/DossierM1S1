library(rvest)

#Voici le code pour scraper toutes les séries et leurs synopsis (environ 9 heures d'éxecution)

grab_info = function() {
  series_info = c()

 #Parcourir les pages du site Allociné
  for (number_of_page in 1:1434) {
    link = paste0("https://www.allocine.fr/series-tv/?page=", number_of_page)
   page_content = read_html(link)

 #Extraire les liens vers chaque série
    links_of_pages = page_content %>% 
      html_nodes('.entity-card-list .meta-title-link') %>% 
      html_attr("href") %>% 
     paste("https://www.allocine.fr", ., sep = "")

 #Extraire les noms et synopsis des séries
    for (serie_page in links_of_pages) {
     page_content = read_html(serie_page)
      serie_name = page_content %>% 
        html_nodes('.titlebar-title-xl .titlebar-link') %>% 
        html_text()
      serie_synopsis <- page_content %>% 
        html_nodes('.bo-p:nth-child(1)') %>% 
        html_text()

      if (length(serie_synopsis) == 0) {
        serie_synopsis = NA
      }

      serie_info = cbind(serie_name, serie_synopsis)
      series_info = rbind(series_info, serie_info)
    }
  }

 #Convertir les informations en DataFrame
  series_info_df = as.data.frame(series_info)
  colnames(series_info_df) = c("serie_name", "serie_synopsis")
  return(series_info_df)
}

# Appeler la fonction pour récupérer les données
data <- grab_info()

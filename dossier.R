library(rvest)
library(dplyr)

nbr_pages = (1:20)

all_names = 1

for (pagenum in nbr_pages) {
  link=paste0("https://www.allocine.fr/series/meilleures/?page=",pagenum)
  page = read_html(link)
  name = page %>% html_nodes('.entity-card-list .meta-title-link')%>% html_text()
  name
  all_names= c(all_names, name)
}


all_names
all_synopsis=1

for (pagenum2 in nbr_pages) {
  link=paste0("https://www.allocine.fr/series/meilleures/?page=",pagenum2)
  page = read_html(link)
  synopsis = page %>% html_nodes('.content-txt')%>% html_text()
  all_synopsis= c(all_synopsis, synopsis)}






all_synopsis

serieees = data.frame(all_names,all_synopsis)






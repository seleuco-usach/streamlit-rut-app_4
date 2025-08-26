
library(googledrive)
library(googlesheets4)
library(dplyr)

VIPO<-  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/19aL6SlUYXi7bx2-TlOuGzB2uYFoHcQQJAZR6BlT4jgw/edit?gid=0#gid=0",
    sheet = "vipo_2",
    col_types = paste(rep("c", 18), collapse = "")
  ) %>% 
  mutate(across(where(is.character), function(x) chartr("ÁÉÍÓÚ", "AEIOU", x)))


table(VIPO$ANHO)

VIPO<-
VIPO %>% mutate(Clave.Año = paste(ANHO, RUT, sep = "-")) %>%
  relocate(Clave.Año, .before = PROGRAMA) %>% 
  add_count(Clave.Año, name="dup") %>% 
  relocate(dup, .after = Clave.Año)

VIPO<-
VIPO %>% filter(dup==1)

#VIPO %>% View()
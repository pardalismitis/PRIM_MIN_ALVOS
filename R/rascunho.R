library(tidyverse)
library(stringr)

caminho_arquivo <- "data_raw/MIN_BH_3_4.csv"

raw <- tibble(
  linha = read_lines(caminho_arquivo)
)
texto_unico <- raw$linha |>
  str_squish() |>
  str_c(collapse = " ")

padrao <- "(\\b\\d+\\b)\\s+(.*?)(?=\\s+\\d+\\s+(Fauna:|$)|$)"

matches <- str_match_all(texto_unico, padrao)[[1]]

df_blocos <- tibble(
  UP = matches[,2],
  texto = str_squish(matches[,3])
) |>
  distinct()

df_blocos <- df_blocos |>
  #mutate(
   # texto = str_replace_all(
    #  texto,
     # "([^;]+?)\\s*:\\s*Flora;",
      #"Flora: \\1;"
  #  )
  #) #|>
  #mutate(
   # texto = str_replace_all(
    #  texto,
     # "Áreas das Formações Pioneiras Vegetação, , ",
      #""
  #  )
  #) |>
  #mutate(
   # texto = str_replace_all(
    #  texto,
     # "Xiphorhynchus atlanticus, Áreas das Formações Pioneiras Vegetação",
      #"Xiphorhynchus atlanticus"
#    )
 # )|>
  # ----------------------------------------------------------------
# Etapa 2: Extração dos blocos por componente
# Cada str_extract captura o trecho entre um rótulo e o próximo
# ----------------------------------------------------------------
mutate(
  Fauna = str_extract(texto, "Fauna:.*?(?=Flora:|Ambientes singulares?:|Serviços ecossistêmicos:|$)"),
  Flora = str_extract(texto, "Flora:.*?(?=Fauna:|Ambientes singulares?:|Serviços ecossistêmicos:|$)"),
  Ambientes = str_extract(texto, "Ambientes singulares?:.*?(?=Fauna:|Flora:|Serviços ecossistêmicos:|$)"),
  Servicos = str_extract(texto, "Serviços ecossistêmicos:.*?(?=Fauna:|Flora:|Ambientes singulares?:|$)")
)|>
  # ----------------------------------------------------------------
# Etapa 3: Remoção dos rótulos dos componentes
# Mantém apenas o conteúdo interno de cada seção
# ----------------------------------------------------------------
mutate(
  Fauna = str_remove(Fauna, "^Fauna:\\s*"),
  Flora = str_remove(Flora, "^Flora:\\s*"),
  Ambientes = str_remove(Ambientes, "^Ambientes singulares?:\\s*"),
  Servicos = str_remove(Servicos, "^Serviços ecossistêmicos:\\s*")
)


correcoes <- read_csv("data_reference/correcoes_padrao.csv")
areasLoucas <- df_blocos |> 
  dplyr::filter(stringr::str_detect(texto, "Áreas das Formações Pioneiras Vegetação"))

areasMuitoLoucas <- areasLoucas |> 
  dplyr::filter(!stringr::str_detect(texto, "Fitofisionomias: Áreas das Formações Pioneiras"))

areasMaisLoucasAinda <- areasMuitoLoucas |> 
  dplyr::filter(!stringr::str_detect(texto, "Fitofisionomias:, Áreas das Formações Pioneiras"))

readr::write_csv(
  df_blocos, "data_raw/IVT_Mata_Atlantica.csv"
)

prep_MA <- read_csv("data_prep/IVT_Mata_Atlantica.csv")

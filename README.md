# PRIM_MIN_ALVOS

Estruturação automatizada dos **alvos de conservação** presentes no
Plano de Redução de Impactos da Mineração sobre a Biodiversidade e o Patrimônio
Espeleológico - PRIM Mineração.

Este repositório contém um pipeline em R desenvolvido para extrair,
padronizar e organizar os alvos de conservação (Fauna, Flora,
Ambientes Singulares e Serviços Ecossistêmicos) a partir dos arquivos brutos
disponíveis no Material Suplementar do PRIM Mineração, transformando o
conteúdo textual em uma base de dados estruturada.

O objetivo é permitir análise, revisão técnica e integração com outras
bases utilizadas nas análises da COESP/CGCON/ICMBio e possíveis
interessados no uso dos dados.

------------------------------------------------------------------------

## Contexto

Nos arquivos originais, os alvos de conservação aparecem como blocos de
texto associados a cada **Unidade de Planejamento (UP)**.

Esses blocos possuem características que podem dificultar análise
direta:

-   texto contínuo
-   separadores inconsistentes
-   pequenas variações de grafia

Este projeto resolve esse problema criando um **pipeline reprodutível**
que transforma os dados em uma base tabular limpa.

------------------------------------------------------------------------

## Estrutura do pipeline

O fluxo de processamento ocorre em cinco etapas principais:

1.  **Parse dos blocos brutos**

    Função: `parse_alvos_brutos()`

    -   lê o arquivo de entrada em formato \*.csv gerado a partir do
        material suplementar
    -   identifica os blocos de texto associados a cada Unidade de
        Planejamento (UP)
    -   produz uma tabela inicial contendo:

    UP \| texto

------------------------------------------------------------------------

2.  **Extração dos componentes**

    Função: `extrai_componentes()`

    -   identifica e separa os blocos:

        -   Fauna
        -   Flora
        -   Ambientes Singulares
        -   Serviços Ecossistêmicos

    -   produz uma tabela com colunas estruturais:

    UP \| Fauna \| Flora \| Ambientes \| Servicos

------------------------------------------------------------------------

3.  **Explosão dos alvos**

    Função: `explode_alvos()`

    -   transforma os componentes em formato **long** (transposto)
    -   separa alvos individuais
    -   remove separadores e ruído textual

    Resultado:

    UP \| COMPONENTE \| ALVO

------------------------------------------------------------------------

4.  **Normalização**

    Função: `normaliza_alvos()`

    -   limpeza estrutural final
    -   aplicação opcional de tabela de correções de grafia

    Arquivo de referência:

    data_reference/correcoes_padrao.csv

------------------------------------------------------------------------

5.  **Pipeline por bacia**

    Função: `processa_bacia()`

    Executa todas as etapas anteriores e adiciona a coluna:

    BACIA

------------------------------------------------------------------------

## Estrutura do repositório

```         
PRIM_MIN_ALVOS
│
├── .gitgnore
├── PRIM_MIN_ALVOS.Rproj
├── README.md
├── processamento_alvos.Rmd
├── processamento_alvos.html
│
├── R
│   ├── 01_parse_alvos.R
│   ├── 02_transforma_long.R
│   ├── 03_normalizacao.R
│   ├── 04_pipeline_bacia.R
│   └── run_pipeline.R
│
├── data_raw
│   ├── MIN_BH_3_4.csv
│   ├── MIN_BH_5_6.csv
│   ├── MIN_BH_7.csv
│   └── MIN_BH_8.csv
│
├── data_reference
│   └── correcoes_padrao.csv
│
└── data_output
    ├── alvos_processados_BH_3_4.csv
    ├── alvos_processados_BH_5_6.csv
    ├── alvos_processados_BH_7.csv
    └── alvos_processados_BH_8.csv
```

------------------------------------------------------------------------

## Disponibilidade dos arquivos de dados

Os arquivos .csv utilizados como entrada no processamento não estão
incluídos neste repositório.

Isso ocorre principalmente por dois motivos:

Tamanho dos arquivos – os arquivos originais possuem grande volume de
dados, o que ultrapassa ou se aproxima dos limites recomendados para
versionamento em repositórios Git.

Boas práticas de versionamento – repositórios de código devem priorizar
scripts, funções e documentação, evitando incluir grandes bases de dados
que podem dificultar o clone, aumentar o histórico do repositório e
comprometer a performance do Git.

Assim, este repositório contém apenas o código necessário para processar
os dados, assumindo que os arquivos de entrada estejam disponíveis
localmente no diretório:

data_raw/

Pesquisadores ou equipes que necessitem acessar os arquivos de dados
utilizados neste pipeline podem solicitá-los diretamente à Coordenação
de Análises Geoespaciais para Conservação de Espécies (COESP/ICMBio).

Após obter os arquivos, basta colocá-los nos respectivos diretórios para
que o pipeline possa ser executado normalmente.

## Execução

Execução (script principal):

```         
R/run_pipeline.R
```

O script principal percorre automaticamente todos os arquivos \*.csv
separados por bacias na pasta `data_raw`.

Arquivos esperados:

```         
MIN_BH_3_4.csv
MIN_BH_5_6.csv
MIN_BH_7.csv
MIN_BH_8.csv
```

Saída gerada:

```         
data_output/alvos_processados_BH_3_4.csv
data_output/alvos_processados_BH_5_6.csv
data_output/alvos_processados_BH_7.csv
data_output/alvos_processados_BH_8.csv
```

Checagem geral:

Verificação e ajustes finos:

```         
processamento_alvos_MIN.Rmd
```

------------------------------------------------------------------------

## Estrutura da base final

Cada linha representa **um alvo de conservação associado a uma UP**.

Colunas:

UP COMPONENTE ALVO BACIA

Exemplo:

| UP  | ALVO                 | COMPONENTE | BACIA    |
|-----|----------------------|------------|----------|
| 101 | Leopardus wiedii     | Fauna      | BH_3_4 |
| 101 | Bertholletia excelsa | Flora      | BH_3_4 |

------------------------------------------------------------------------

## Dependências

Pacotes utilizados:

```         
tidyverse
stringr
purrr
readr
glue
```

Instalação:

```         
install.packages("tidyverse")
install.packages("glue")
```

------------------------------------------------------------------------

## Objetivo

Criar uma base consistente de alvos de conservação para:

-   revisão técnica
-   análise espacial
-   integração com dados geoespaciais
-   suporte a análises do PRIM-MIN
-   padronização metodológica interna

------------------------------------------------------------------------

## Autoria

COESP/CGCON/DIBIO/ICMBio

Coordenação de Análises Geoespaciais para Conservação de Espécies -
COESP

Coordenação Geral de Estratégias para Conservação - CGCON

Diretoria de Pesquisa, Avaliação e Monitoramento da Biodiversidade -
DIBIO

Instituto Chico Mendes de Conservação da Biodiversidade - ICMBio

[coesp\@icmbio.gov.br](mailto:coesp@icmbio.gov.br)

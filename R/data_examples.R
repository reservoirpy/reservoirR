#' Datagouv covid-19 dataset
#'
#' A dataset containing the data from datagouv.fr concerning covid-19 infections in Aquitaine. Data related to hospitalizations can be found at Santé publique France  - Data downloaded at https://www.data.gouv.fr/fr/datasets/r/08c18e08-6780-452d-9b8c-ae244ad529b3, update from 26/01/2023. Data related to RT-PCR can be found at Santé publique France  - Data downloaded at https://www.data.gouv.fr/fr/datasets/r/10639654-3864-48ac-b024-d772c218c4c1, update from 26/01/2023.
#'
#' \itemize{
#'   \item date. The date
#'   \item hosp. Number of person hospitalized with SARS-CoV-2 in Aquitaine.
#'   \item Positive. Number of person with a positive RT-PCR in Aquitaine.
#'   \item Tested. Number of person with a RT-PCR in Aquitaine.
#' }
#'
#' @docType data
#' @keywords datasets
#' @name dfCovid
#' @usage data(dfCovid)
#' @format A data frame with 962 rows and 4 variables
NULL

# script generating dfCovid
# library(dplyr)
# dfHospit <- read.csv("https://www.data.gouv.fr/fr/datasets/r/08c18e08-6780-452d-9b8c-ae244ad529b3",
#                      sep = ";") %>%
#   filter(reg == 75, cl_age90 == 0) %>%
#   select(jour, hosp)
# 
# dfPCR <- read.csv("https://www.data.gouv.fr/fr/datasets/r/10639654-3864-48ac-b024-d772c218c4c1",
#                      sep = ";",
#                   dec = ",") %>%
#   filter(reg == 75, cl_age90 == 0) %>%
#   select(jour, Positive = P, Tested = "T")
# 
# dfCovid <- dfHospit %>%
#   full_join(dfPCR, by = "jour") %>%
#   filter(jour > "2020-05-13", jour < "2023-01-01") %>%
#   mutate(date = as.Date(jour), .before = 1) %>%
#   select(-jour)
# 
# save(dfCovid, file = "data/dfCovid.rdata")

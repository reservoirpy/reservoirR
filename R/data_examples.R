#' Bordeaux University Hospital covid-19 dataset
#'
#' A dataset containing the Bordeaux Hospital covid-19 data (obfuscated < 10).
#'
#' \itemize{
#'   \item date. The date
#'   \item hospitalisations. Number of person hospitalised in Bordeaux Hospital at a given date (obfuscated < 10)
#'   \item iptcc. The IPTCC index
#'   \item positive_pcr. Number of covid-19 positive RT-PCR in Bordeaux Hospital at a given date (obfuscated < 10)
#' }
#'
#' @docType data
#' @keywords datasets
#' @name dfCovid
#' @usage data(dfCovid)
#' @format A data frame with 612 rows and 4 variables
NULL

# script generating dfCovid
# library(dplyr)
# dfCovid <- readRDS("../PredictCovid/extdata/publication_datasets/lsEDSOpen.rds")$dfEDS %>%
#   select(date = START_DATE, hospitalisations = hosp, iptcc = IPTCC.mean, positive_pcr = P_TOUS_AGES) %>%
#   mutate_at(.vars = c("hospitalisations", "positive_pcr"), .funs = function(x) ifelse(x <= 10, 0, x))
# 
# save(dfCovid, file = "data/dfCovid.rdata")

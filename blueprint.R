# 1. Set up ====================================================================================================
library(tidyverse)
library(httr)
library(jsonlite)
library(assertthat)
library(keyringr)
library(magrittr)
library(googledrive)
library(googlesheets4)

baseurl <- "https://sandbox.psi-mis.org/"
base <- substr(baseurl,9,27)

login_dhis2 <- function(baseurl, usr, pwd){
  GET(paste0(baseurl, "api/me"), authenticate(usr, pwd)) -> r
  assert_that(r$status_code == 200L)
}

# login to sandbox
login_dhis2(baseurl, get_kc_account(base, "internet"), decrypt_kc_pw(base, "internet"))


# 2. Get blueprints ==============================================================================================
country <- drive_get("Countries")

countries <- drive_ls(country$path)

blueprints <- map(file.path(country$path,countries$name, fsep = ""), drive_ls) %
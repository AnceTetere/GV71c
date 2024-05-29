#Iztrādā šablonu GV71c_yyyyQQ un apakštabulas

#1 Sākotnējo izstrādes tabulu ņem no iepriekšējā ceturkšņa
if (Q == "1") {
  prev <- as.character(as.numeric(year) - 1)
  setwd(paste0(base_path, prev, "//", prev, "Q4//GB_fails"))
  rm(prev)
} else {
  setwd(paste0(base_path, year, "Q", as.numeric(Q)-1, "//GB_fails"))
}

GV71c <- read.csv2("GV71c.csv")
initT <- GV71c
rm(GV71c)

initT$rindas <- paste0(initT$TIME, initT$SECTOR, initT$AREA)
rindas1 <- initT$rindas

if(!dir.exists("intermediate_tables")) {
  dir.create("intermediate_tables")
}
saveRDS(rindas1, file = "intermediate_tables//rindas1.RDS")

initT$EMPL_FTU[is.na(initT$EMPL_FTU)] <- ""
initT$EMPL_FTU_X[is.na(initT$EMPL_FTU_X)] <- ""

if(!dir.exists("intermediate_tables//fails_datubazei")){
  dir.create("intermediate_tables//fails_datubazei")}
initial_GV71c <- initT
save(initial_GV71c, file = "intermediate_tables//fails_datubazei//1_initial_GV71c.RData")
rm(initial_GV71c)
#

cet <- ifelse(Q == "1", 
              paste0(as.numeric(year) - 1, "Q4"), 
              paste0(year, "Q", as.numeric(Q)-1))

c <- initT[initT$TIME == cet, ]
rm(initT, cet)

new_cet <- paste0(year, "Q", Q)
c$TIME <- new_cet
rm(new_cet)

rownames(c) <- NULL
c$rindas <- paste0(c$TIME, c$SECTOR, c$AREA)
rindas2 <- c$rindas
saveRDS(rindas2, file = "intermediate_tables//rindas2.RDS")

rindas <- append(rindas1, rindas2)
saveRDS(rindas, file = "intermediate_tables//rindas.RDS")
rm(rindas1)

c$EMPL_FTU <- ""
c$SECTOR <- factor(c$SECTOR)
levels(c$SECTOR)

template_name <- paste0("template_GV71c_", year, "Q", Q)
assign(template_name, c)
save(list = template_name, file = paste0("intermediate_tables//", template_name, ".RData"))
rm(list = template_name, template_name)

#Sadala datu rāmi faktorizētās tabulās
c <- split(c, c$SECTOR)
list2env(c, envir = .GlobalEnv)

GEDOV_S <- `GEDOV-S`
GEDOV_S_ST <- `GEDOV-S_ST`
GEDOV_S_L_DOV <- `GEDOV-S_L_DOV`
PRIVs <- `PRIV-S`
PUBs <- `PUB-S`
rm(`PUB-S`, c,  `PRIV-S`, `GEDOV-S`, `GEDOV-S_ST`, `GEDOV-S_L_DOV`)

subSECTORS <- readRDS(paste0(base_path, "R_kods//templates//subSECTORS.RDS"))

for (i in 1:length(subSECTORS)) {
  df <- get(subSECTORS[i])
  rownames(df) <- NULL
  assign(subSECTORS[i], df)
  save(list = subSECTORS[i], file = paste0("intermediate_tables//", subSECTORS[i], "_", year, "Q", Q, ".RData"))
  rm(df)
}
rm(i, c)

reg_vec <- readRDS(paste0(base_path, "R_kods//templates//regi.RDS"))
pils_vec <- readRDS(paste0(base_path, "R_kods//templates//pilsetas.RDS"))

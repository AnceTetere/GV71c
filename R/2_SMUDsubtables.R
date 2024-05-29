# Izstrādā GMUD tabulu un sadala to

s <- x 
s <- s[s$NOZARE2 == "0", ]
rm(x)

aile <- paste0("G", Q)
s <- s[,c("NSV", "DAT", "NTABL", "RAJ", "Nos", aile)]
rownames(s) <- NULL

source(paste0(base_path, "R_kods//fnc_rename_dataframes.R"))

s$NSV <- factor(s$NSV)
s_split <- split(s, s$NSV)
s_split <- rename_dataframes(s_split, "k")
list2env(s_split, envir = .GlobalEnv)
if(exists("k_025")){rm(k_025)}

k_GMUD <- c("k_001", "k_023", "k_024", "k_050", "k_058", "k_083")
GMUD_subTables <- vector()

for(i in 1:length(subSECTORS)) {
a <- get(subSECTORS[i])
b <- get(k_GMUD[i])
mT <- paste0(subSECTORS[i], substr(k_GMUD[i], 2, 5))
#GMUD pārveide
b$RAJ[b$RAJ %in% substr(pils_vec, 1, nchar(pils_vec)-2)] <-
  paste0(b$RAJ[b$RAJ %in% substr(pils_vec, 1, nchar(pils_vec)-2)], "00")

#Tāpat GMUD datne bieži nes dubultniekus, tos izņem sapludināšanas procesā.
if(sum(unique(b$RAJ) %in% a$AREA) == 53) {
  M <- merge(a, b[!duplicated(b$RAJ), c("RAJ", aile)], by.x = "AREA", by.y = "RAJ", all.x = TRUE)
} else {
  stop("Vērtības AREA ailē tabulā ", subSECTORS[i], " nesakrīt ar vērtībām RAJ ailē tabulā ", k_GMUD[i])
}

M$EMPL_FTU <- M[ ,aile]
M <- M[,colnames(a)]

assign(mT, M)
GMUD_subTables <- append(GMUD_subTables, mT)
rm(list = c(subSECTORS[i], k_GMUD[i]), a, b, mT, M)
}

rm(k_GMUD, subSECTORS, s, s_split, i)

#GMUD_subTables <- c("TOTAL_001", "PUBs_023", "PRIVs_024", "GEDOV_S_050", "GEDOV_S_ST_058", "GEDOV_S_L_DOV_083")

for (i in 1:length(GMUD_subTables)) {
save(list = GMUD_subTables[i], 
     file = paste0("intermediate_tables//k", substr(GMUD_subTables[i], nchar(GMUD_subTables[i])-2, nchar(GMUD_subTables[i])), "_", substr(GMUD_subTables[i], 1, nchar(GMUD_subTables[i])-4), "_", year, "Q", Q, ".RData"))
  #rm(list = subSECTORS[i])
}
rm(i)

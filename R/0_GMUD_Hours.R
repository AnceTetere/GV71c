base_path <- "..//GV71c_regPilsNovadiCeturksnī//"
year <- readline(prompt = "Ievadīt gadu:")
Q <- readline(prompt = "Ievadīt ceturksni:")
path <- paste0(base_path, year, "Q", Q, "//")
setwd(path)

tab_name <- paste0("GMUD_Hours_", substr(year, 3, 4), "c", Q)
load(paste0("..\\GVS10c\\", year, "Q", Q, "\\GMUD\\", tab_name, ".RData"))
x <- get(tab_name)
rm(list = tab_name, tab_name)

x$NSV <- factor(x$NSV)
levels(x$NSV)

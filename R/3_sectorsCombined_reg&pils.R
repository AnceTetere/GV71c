#Sašujam ceturksni kopā
f <- data.frame()

for (i in 1:length(GMUD_subTables)) {
  f <- rbind(f, get(GMUD_subTables[i]))
  rm(list = GMUD_subTables[i])
}
rm(i, aile, pils_vec, reg_vec, GMUD_subTables)

f <- f[match(rindas2, f$rindas), ]
name <- paste0("final_", year, "Q", Q)
assign(name, f)
save(list = name, file = paste0("intermediate_tables//", name, ".RData"))
rm(list = name)

additional_GV71c <- f
save(additional_GV71c, file = paste0("intermediate_tables//fails_datubazei//2_additional_GV71c.RData"))
rm(f)

f <- rbind(initial_GV71c, additional_GV71c)
f <- f[match(rindas,f$rindas), ]
f$rindas <- NULL
rownames(f) <- NULL
final_GV71c <- f
rm(f, initial_GV71c, additional_GV71c, rindas, rindas2)

save(final_GV71c, file = paste0("intermediate_tables//fails_datubazei//3_final_GV71c.RData"))
write.table(final_GV71c, "intermediate_tables//fails_datubazei//final_GV71c.csv", sep = ";", col.names = TRUE, row.names = FALSE, qmethod = "double")

rm(final_GV71c, base_path, name, path, Q, year, "rename_dataframes")

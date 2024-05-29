rename_dataframes <- function(data_list, prefix) {
  names(data_list) <- paste0(prefix, "_", names(data_list))
  return(data_list)
}

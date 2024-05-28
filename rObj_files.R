setwd("~/Downloads")

# Install the bsseq package using BiocManager
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("bsseq")

# Select the file
T <- file.choose()
print(T) # Print the file path to verify

if (grepl("\\.robj$", T)) {
  # Load the .robj file
  load(T)
  print("File loaded successfully.")
} else {
  stop("Selected file does not have a .robj extension.")
}

# List all objects in the environment
loaded_objects <- ls()
print(loaded_objects)

# Inspect each loaded object
for (obj in loaded_objects) {
  cat("Inspecting object:", obj, "\n")
  print(str(get(obj)))  # Display structure of each object
  cat("\n")
}

# Check if 'bs' is in the environment
if ("bs" %in% loaded_objects) {
  # Display the structure of 'bs'
  str(bs)
  
  # Extract data from 'bs' if it's a BSseq object
  if (inherits(bs, "BSseq")) {
    # Extract methylation and coverage data
    meth_data <- getMeth(bs, type = "raw")
    cov_data <- getCoverage(bs, type = "Cov")
    
    # Convert to data frames
    meth_df <- as.data.frame(meth_data)
    cov_df <- as.data.frame(cov_data)
    
    # Combine data frames (assuming the row and column names match)
    combined_df <- data.frame(
      SampleID = rownames(meth_df), 
      meth_df, 
      Coverage = cov_df
    )
    
    # Export to CSV
    write.csv(combined_df, "exported_bs.csv", row.names = FALSE)
    cat("BSseq data exported to 'exported_bs.csv'.\n")
  } else if (is.data.frame(bs)) {
    write.csv(bs, "exported_bs.csv", row.names = FALSE)
    cat("Data frame 'bs' exported to 'exported_bs.csv'.\n")
  } else {
    cat("Object 'bs' is not a data frame or a BSseq object and cannot be directly exported to CSV.\n")
  }
} else {
  cat("Object 'bs' not found in the environment.\n")
}

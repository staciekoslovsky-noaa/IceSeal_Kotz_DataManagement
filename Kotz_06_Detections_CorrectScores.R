# Correct confidence values
# S. Hardy, 10 August 2020

# Install libraries
library(tidyverse)

# Set variables for processing
wd <- "C:/Users/stacie.hardy/Work/Work/Projects/AS_Detections/Data/Kotz_2019/F07"
original_file <- "2019TestF7L_tinyYolo_eo_20200221_originalRGB.csv"
processed_file <- "2019TestF7L_tinyYolo_eo_20200221_processedRGB.csv"
output_file <- "2019TestF7L_tinyYolo_eo_20200221_updatedRGB.csv"

# Import data to R session
setwd(wd)

fields <- max(count.fields(original_file, sep = ','))
original <- read.csv(original_file, header = FALSE, stringsAsFactors = FALSE, skip = 2, col.names = paste("V", seq_len(fields)))
if(fields == 11) {
  colnames(original) <- c("hotspot_o", "frame_o", "xmin_o", "ymin_o", "xmax_o", "ymax_o", "not_sure_o", "confidence_o", "unsure_o", "type_o", "confidence2_o")
} else if (fields == 13) {
  colnames(original) <- c("hotspot_o", "frame_o", "xmin_o", "ymin_o", "xmax_o", "ymax_o", "not_sure_o", "confidence_o", "unsure_o", "type_o", "confidence2_o", "type_o_x1", "confidence2_o_x1")
}

processed <- read.csv(processed_file, header = FALSE, stringsAsFactors = FALSE, col.names = c("hotspot", "frame", "xmin", "ymin", "xmax", "ymax", "not_sure", "confidence", "unsure", "type", "confidence2"))
rm(original_file, processed_file, fields)

# Update processed confidence values
detections <- processed %>%
  left_join(original, by = c("hotspot" = "hotspot_o")) %>%
  mutate(confidence = ifelse(confidence != 1 & confidence != confidence_o, confidence_o, confidence),
         confidence2 = ifelse(confidence != confidence2, confidence, confidence2)) %>%
  select(c("hotspot", "frame", "xmin", "ymin", "xmax", "ymax", "not_sure", "confidence", "unsure", "type", "confidence2"))

# Export data
write.table(detections, output_file, sep = ",", quote = FALSE, row.names = FALSE, col.names = FALSE)

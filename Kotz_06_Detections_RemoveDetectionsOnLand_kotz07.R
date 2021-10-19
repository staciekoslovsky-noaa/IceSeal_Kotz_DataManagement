library(stringr)

# Process LEFT images
processed <- read.csv("c:/skh/2019TestF7L_tinyYolo_eo_20200221_processed.csv", stringsAsFactors = FALSE, header = FALSE)
images_to_remove <- read.table("c:/skh/2019TestF7L_ImagesOnLand_20200224_SKH.txt", stringsAsFactors = FALSE, header = FALSE)

processed$V2 <- str_remove(processed$V2, "/run/media/ben.hou/AK Seals 2/fl07/LEFT/")
processed <- processed[!processed$V2 %in% images_to_remove$V1, ]

processed$V2 <- paste("/run/media/ben.hou/AK Seals 2/fl07/LEFT/", processed$V2, sep = "")

write.csv(processed, "c:/skh/2019TestF7L_tinyYolo_eo_20200221_processedWithoutLand.csv", row.names = FALSE, col.names = NA)

# Process CENT images
processed <- read.csv("c:/skh/2019TestF7C_tinyYolo_eo_20200219_processed.csv", stringsAsFactors = FALSE, header = FALSE)
images_to_remove <- read.table("c:/skh/2019TestF7C_ImagesOnLand_20200224_SKH.txt", stringsAsFactors = FALSE, header = FALSE)

processed$V2 <- str_remove(processed$V2, "/run/media/ben.hou/AK Seals 2/fl07/CENT/")
processed <- processed[!processed$V2 %in% images_to_remove$V1, ]

processed$V2 <- paste("/run/media/ben.hou/AK Seals 2/fl07/CENT/", processed$V2, sep = "")

write.csv(processed, "c:/skh/2019TestF7C_tinyYolo_eo_20200219_processedWithoutLand.csv", row.names = FALSE, col.names = NA)

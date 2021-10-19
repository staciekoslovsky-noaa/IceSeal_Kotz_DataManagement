fl07_C <- read.table("C:/Users/stacie.hardy/Work/Work/Projects/AS_Detections/Data/Kotz_2019/F07/2019TestF7C_tinyYolo_eo_20200219_original_imagesRGB_manualReview.txt", stringsAsFactors = FALSE)
fl07_L <- read.table("C:/Users/stacie.hardy/Work/Work/Projects/AS_Detections/Data/Kotz_2019/F07/2019TestF7L_tinyYolo_eo_20200221_original_imagesRGB_manualReview.txt", stringsAsFactors = FALSE)

file.copy(paste('D:/fl07/CENT', fl07_C$V1, sep = "/"), "C:/skh/fl07_manualReview")
file.copy(paste('D:/fl07/LEFT', fl07_L$V1, sep = "/"), "C:/skh/fl07_manualReview")
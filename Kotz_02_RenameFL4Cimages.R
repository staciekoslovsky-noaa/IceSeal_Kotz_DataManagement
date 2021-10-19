wd <- "D:\\Kotz\\fl04\\CENT\\MismatchedImages_Corrected"
setwd(wd)

image_changes <- read.csv('2019TestF4C_imagesRGB_MismatchCorrections_20201116.csv', header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(image_changes)){
  file.rename(image_changes$source[i], image_changes$destination[i])
}
 
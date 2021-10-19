get_nth_element <- function(vector, starting_position, n) { 
  vector[seq(starting_position, length(vector), n)] 
}

images <- read.table("C:\\Users\\stacie.hardy\\Work\\Work\\Projects\\AS_Detections\\Data\\Kotz_2019\\F07\\2019TestF7L_tinyYolo_eo_20200221_original_imagesRGB_all.txt")
colnames(images) <- "image"
images <- data.frame(images = get_nth_element(images$image, sample(1:20, 1), 20), stringsAsFactors = FALSE)

write.table(images, "C:\\Users\\stacie.hardy\\Work\\Work\\Projects\\AS_Detections\\Data\\Kotz_2019\\F07\\2019TestF7L_tinyYolo_eo_20200221_original_imagesRGB_manualReview.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
a
# Create functions -----------------------------------------------
# Function to install packages needed
install_pkg <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Install libraries ----------------------------------------------
install_pkg("tiff")

wd_get <- "C:/Users/stacie.hardy/Desktop/fl01_IRimages/"
wd_save <- "C:/skh/fl01_C_correctedIR/"

images <- list.files(path = wd_get, pattern = "ir.tif")

for (i in 1:length(images)){
  x <- tiff::readTIFF(paste(wd_get, images[i], sep = "/"))
  x <- x[-1,]
  tiff::writeTIFF(x, paste(wd_save, images[i], sep = "/"), bits.per.sample = 16L, compression = "none", reduce = FALSE)
}





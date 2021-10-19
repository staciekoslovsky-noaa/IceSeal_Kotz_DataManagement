# In Flight System: Process Data/Images to DB
# S. Hardy, 5APR2019

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

# Run code -------------------------------------------------------
# Process test and calibration flights ---------------------------
# Set initial working directory
wd <- "//nmfs/akc-nmml/Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/test_flights_2019/test_kotz_2019"
setwd(wd)

# # Process flight 1 ------------------------------------- COMPLETED 6/14/2019!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# # Flatten CENT, LEFT, RGHT folders (completed 6/13/2019 11 pm...took ~36 hours)
#dirs <- list.dirs(paste(wd, "fl01/CENT", sep = "/"), full.names = FALSE, recursive = FALSE)
# for (i in 1:length(dirs)){
#   dir <- paste(wd, "fl01/CENT", dirs[i], sep = "/")
#   files <- list.files(dir)
#   file.copy(file.path(dir, files), paste(wd, "fl01/CENT", sep = "/"))
#   unlink(file.path(dir, files))
#   unlink(dir, recursive = TRUE)
# }
# rm(dirs, dir, files)
# 
# dirs <- list.dirs(paste(wd, "fl01/RGHT", sep = "/"), full.names = FALSE, recursive = FALSE)
# for (i in 1:length(dirs)){
#   dir <- paste(wd, "fl01/RGHT", dirs[i], sep = "/")
#   files <- list.files(dir)
#   file.copy(file.path(dir, files), paste(wd, "fl01/RGHT", sep = "/"))
#   unlink(file.path(dir, files))
#   unlink(dir, recursive = TRUE)
# }
# rm(dirs, dir, files)
# 
# dirs <- list.dirs(paste(wd, "fl01/LEFT", sep = "/"), full.names = FALSE, recursive = FALSE)
# for (i in 1:length(dirs)){
#   dir <- paste(wd, "fl01/LEFT", dirs[i], sep = "/")
#   files <- list.files(dir)
#   file.copy(file.path(dir, files), paste(wd, "fl01/LEFT", sep = "/"))
#   unlink(file.path(dir, files))
#   unlink(dir, recursive = TRUE)
# }
# rm(dir, dirs, files, i)
# 
# # Correct image names (completed 6/14/2019)
# dir <- paste(wd, "fl01/CENT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 5), "fl", substring(files$file, 6, 8), "C", substring(files$file, 10, 32), "_", substring(files$file, 34, nchar(files$file)), sep = "")
# files$new_name <- paste("test", files$file, sep = "_")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)
# 
# dir <- paste(wd, "fl01/LEFT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 5), "fl", substring(files$file, 6, 8), "L", substring(files$file, 10, 32), "_", substring(files$file, 34, nchar(files$file)), sep = "")
# files$new_name <- paste("test", files$file, sep = "_")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)
# 
# dir <- paste(wd, "fl01/RGHT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 5), "fl", substring(files$file, 6, 8), "R", substring(files$file, 10, 32), "_", substring(files$file, 34, nchar(files$file)), sep = "")
# files$new_name <- paste("test", files$file, sep = "_")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)

# # Process flight 2 (pilot-only flight...no updates needed)

# # Process flight 3 (calibration...no updates completed at this time)

# # Process flight 4 ------------------------------------- COMPLETED 6/14/2019!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# # Correct naming for C images (completed 6/14/2019)
# dir <- paste(wd, "fl04/CENT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 15), "fl", substring(files$file, 16, nchar(files$file)), sep = "")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)
# 
# Correct mis-named L/R images (completed 6/14/2019)..undone 2/21/2020. file names were correct in the field...oops
dir <- paste(wd, "fl04/RGHT", sep = "/")
files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
files$new_name <- paste(substring(files$file, 1, 15), "fl04_L_", substring(files$file, 25, nchar(files$file)), sep = "")
files$fileP <- paste(dir, files$file, sep = "/")
files$new_nameP <- paste(dir, files$new_name, sep = "/")
file.rename(files$fileP, files$new_nameP)

dir <- paste(wd, "fl04/LEFT", sep = "/")
files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
files$new_name <- paste(substring(files$file, 1, 15), "fl04_R_", substring(files$file, 25, nchar(files$file)), sep = "")
files$fileP <- paste(dir, files$file, sep = "/")
files$new_nameP <- paste(dir, files$new_name, sep = "/")
file.rename(files$fileP, files$new_nameP)
#
# # Then manually change folder names to match images!

# Process flight 5 ------------------------------------- COMPLETED 6/4/2019!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Correct naming for images (completed 6/14/2019)
# dir <- paste(wd, "fl05/CENT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 15), "fl", substring(files$file, 16, nchar(files$file)), sep = "")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)
# 
# dir <- paste(wd, "fl05/LEFT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 15), "fl", substring(files$file, 16, nchar(files$file)), sep = "")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)
# 
# dir <- paste(wd, "fl05/RGHT", sep = "/")
# files <- data.frame(file = list.files(dir), stringsAsFactors = FALSE)
# files$new_name <- paste(substring(files$file, 1, 15), "fl", substring(files$file, 16, nchar(files$file)), sep = "")
# files$fileP <- paste(dir, files$file, sep = "/")
# files$new_nameP <- paste(dir, files$new_name, sep = "/")
# file.rename(files$fileP, files$new_nameP)

# Process polar bear flights ------------------------------------- COMPLETED 6/4/2019!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# # Set initial working directory
# wd <- "//nmfs/akc-nmml/Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/polar_bear_2019"
# setwd(wd)
# 
# # Create list of flight folders 
# dir <- list.dirs(wd, full.names = FALSE, recursive = FALSE)
# dir <- data.frame(path = dir[grep("fl", dir)], stringsAsFactors = FALSE)
# 
# for (i in 10:14){#nrow(dir)){
#   # Create list of image folders
#   image_dir <- merge(dir$path[i], c("LEFT", "CENT", "RGHT"), ALL = true)
#   colnames(image_dir) <- c("path", "camera_loc")
#   image_dir$camera_dir <- paste(wd, image_dir$path, image_dir$camera_loc, sep = "/")
#   
#   # Create list of files and rename (completed 6/4/2019)
#   for (j in 1:nrow(image_dir)){
#     files <- list.files(image_dir$camera_dir[j], pattern = "polar_bear_2019*", full.names = FALSE, recursive = FALSE)
#     files <- data.frame(file = files, stringsAsFactors = FALSE)
#     files$fileP <- paste(image_dir$camera_dir[j], files$file, sep = "/")
#     files$new_name <- paste(substring(files$file, 1, 16), "fl", substring(files$file, 17, nchar(files$file)), sep = "")
#     files$new_nameP <- paste(image_dir$camera_dir[j], files$new_name, sep = "/")
#     file.rename(files$fileP, files$new_nameP)
#   }
# }
#
# # Create list of logs and rename files (completed 6/4/2019)
# for (i in 1:nrow(dir)){
#   logs <- data.frame(files = list.files(dir$path[i], pattern = '.txt', full.names = FALSE, recursive = FALSE), stringsAsFactors = FALSE)
#   logs$filesP <- paste(wd, dir$path[i], logs$files, sep = "/")
#   logs$new_name <- paste(substring(logs$files, 1, 16), "fl", substring(logs$files, 17, 21), substring(logs$files, 23, nchar(logs$files)), sep = "")
#   logs$new_nameP <- paste(wd, dir$path[i], logs$new_name, sep = "/")
#   file.rename(logs$filesP, logs$new_nameP)
# }
#
# # Rename UV images (completed 6/4/2019)
# wd <- "//nmfs/akc-nmml/Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/polar_bear_2019/fl19/CENT"
# setwd(wd)
# 
# images <- list.files(pattern = "*UV*", full.names = TRUE, recursive = FALSE)
# images <- data.frame(pics = images, stringsAsFactors = FALSE)
# images$new_name <- paste("./polar_bear_2019_fl19_C_", substring(images$pics, 22, 40), "000_uv.tif", sep = "")
# images$new_name <- gsub("-", "_", images$new_name)
# file.rename(images$pics, images$new_name)
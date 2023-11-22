# Ice Seal and Polar Bear Survey Data Management

This repository stores the code associated with managing data collected during the Kotzebue and Dead Horse ice seal and polar bear test flights in 2019. Code numbered 0+ are intended to be run sequentially as the data are available for processing. Code numbered 99 are stored for longetivity, but are intended to only be run once to address a specific issue or run as needed, depending on the intent of the code.

The data management processing code is as follows:
* **Kotz_01_ProcessData2DB_polar_bear.R** - code to import image and associated metadata into the DB
* **Kotz_01_ProcessData2DB_test_kotz.R** - code to 
* **Kotz_01_ProcessFootprints2DB_polar_bear.R** - code to import post-processing footprints into the DB
* **Kotz_01_ProcessFootprints2DB_test_kotz.R** - code to 
* **Kotz_02_CleanUpData.R** - code to clean up known issues in the test data
* **Kotz_02_RenameFL4Cimages.R** - code to rename flight #4 images (due to issues during the original data collection)
* **Kotz_03_DebayerRGB_C.py** - code to debayer the center camera RGB images
* **Kotz_03_DebayerRGB_L.py** - code to 
* **Kotz_03_DebayerRGB_R.py** - code to 
* **Kotz_03_RemoveFirstRowIR.R** - code to remove the first line in the IR images (that was incorrectly collected)
* **Kotz_04_Detections_FilterImagesOnLand.txt** - SQL code to filter images that fall on land
* **Kotz_04_Detections_ManualImageList.R** - code to generate list of images to be manually reviewed
* **Kotz_04_Detections_ManualImages_Copy2Drive.R** - code to copy images that will be manually reviewed to an external HD
* **Kotz_05_Detections_ProcessDetections2DB_KotzIR.R** - code to import test_kotz IR processed detections to the DB
* **Kotz_05_Detections_ProcessDetections2DB_KotzRGB.R** - code to import test_kotz RGB processed detections to the DB
* **Kotz_05_Detections_ProcessDetections2DB_PolarBearIR.R** - code to import polar_bear IR processed detections to the DB
* **Kotz_05_Detections_ProcessDetections2DB_PolarBearRGB.R** - code to import polar_bear RGB processed detections to the DB
* **Kotz_05_Detections_ProcessDetections2DB_PolarBearRGB_ManualReview.R** - code to import polar_bear IR manually reviewed annotations to the DB
* **Kotz_06_Detections_CorrectScores.R** - code to correct scores in the processed detections
* **Kotz_06_Detections_RemoveDetectionsOnLand_kotz07.R** - code to remove detection from test_kotz fl07 that fall on land

Other code in the repository includes:
* Code for adding the network path to the image metadata in the DB:
	* Kotz_99_Add_image_dir.txt

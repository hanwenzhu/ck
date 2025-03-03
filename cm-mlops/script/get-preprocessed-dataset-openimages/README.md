# Get Preprocessed Open Images Dataset
This [CM script](https://github.com/mlcommons/ck/blob/master/cm/docs/tutorial-scripts.md) preprocesses the Imagenet dataset.

## How To
```bash
cm run script --tags=get,imagenet,preprocessed,_[VARIATION] --dir=[DIRECTORY] --threads=[NUM_THREADS]
```
where, 
* `[DIRECTORY]:` is the folder to store the preprocessed dataset. Default is current work directory
* `[NUM_THREADS:]` is the number of threads to do preprocessing. Default is number of host cpus. 
and the supported [VARIATIONS] (comma separated and beginning with _) are
*`[1]:` Preprocess only 1 image
*`[500]:` Preprocess first 500 images
*`[full]:` Preprocess the full dataset
*`[validation]:` Preprocess the validation dataset
*`[calibration]:` Preprocess the calibration dataset
*`[NHWC]:` Preprocess the dataset with `Channel` component at end
*`[NCHW]:` Preprocess the dataset with `Channel` component at beginning

## Input Variables coming from Dependencies
* `[CM_DATASET_PATH]:` Folder path to Imagenet dataset
* `[CM_DATASET_IMAGES_LIST]:` File path containing the image names
* `[CM_DATASET_OPENIMAGES_RESIZE]:` Image width to resize to (default 800)

## Exported Variables
* `[CM_DATASET_PREPROCESSED_PATH]:` Directory where the preprocessed images are stored



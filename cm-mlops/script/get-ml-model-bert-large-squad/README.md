# Get ML Model Bert-Large
This [CM script](https://github.com/mlcommons/ck/blob/master/cm/docs/tutorial-scripts.md) downloads the Bert-Large model and adds it to CM cache with relevant meta data. 

## How To
```bash
cm run script --tags=get,ml-model,bert,_[VARIATION]
```
where,
* `[VARIATION]` is one of `fp32`, `int8`, `onnxruntime` (alias `onnx`)

## Exported Variables
* `CM_ML_MODEL_FILE:` Model filename
* `CM_ML_MODEL_FILE_WITH_PATH:` Full path to model file
* `CM_ML_MODEL_PATH:` Path to folder containing the model file
* More env variables being exported are given in [cm.json file](_cm.json)


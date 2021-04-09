Notes from meeting with Andy 


## 20210409

About manifest.json:
- url - gear link   
- source - algorithm  
- license MIT   
- suite -> drop down menu when you try to run gears   
- docker-image -> flywheel/nameofgear:version  (semantic versioning - major.minor.patch) -> first three numbers are gear version and last three numbers of algorithms   
- enums: set to 'nifti' or 'csv' or 'dicom' or '.dat?' 
- full manifest schema: https://github.com/flywheel-io/gears/blob/master/spec/manifest.schema.json
- instead of run.sh could define run.py (but it has to set all env variables correctly within python) 
- make sure that file is +x locally (when pushing to flywheel via CLI e.g. `fw gear upload`) in addition to being executable within docker environment (docker environment variables don't get passed...) (https://github.com/sergeicu/dce_recon_gear/blob/main/run.sh  must be executable in local directory and docker file...) 


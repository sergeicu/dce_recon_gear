1. redesign dce_recon input file handling 
2. modify input handling for run.sh script (based on above)

For 1. 
CURRENT: 
```
    Args:
        NAME (str): name of patient in the First_Last format
        CSV (str): path to .csv file that contains NAME (must be matched), MRN number, full path to raw data and 'timepoints' variable
        OUTPUTDIR (str): full path to output directory where to write files 
        reconResultsSCANdir (str): full path to directory that has the following subdir and file structure: strcat(reconResultsSCANdir,patientName{ss},'_seq1/reconSCAN_T0.nii')
        
```


NEW - option A: 
```
    Args: 
    Args:
        NAME (str): name of patient in the First_Last format
        CSV (str): change paths to related w.r.t. docker / gear container (must point to: output/ directory by convention of flywheel gears) 
        OUTPUTDIR (str): deprecate - this should be written to 'outputs' always. Outputs should be mapped to wherever docker is pointing to.
        reconResultsSCANdir (str): must point to /output inside the docker / gear container. Ideally we need to remove this and make into single reference file instead. 
        
        
```

NEW - option B: 
```
    Args: 
        NAME (str): unload this to .json file 
        SEQ_POINTS (str): unload to .json file specify how many input files matlab binary shall expect 
        TIME_POINTS (STR): unload to .json file - specify time points from .csv file
        OUTPUTDIR (str): make path relative (for gear and docker purposes)
        DAT_FILE (str): full path to raw data recon file(s)
        NII_FILE (str): full path to siemens reconstructed reference .nii file(s)
        
        
```
        
        
        
NEW - option C: 
```
    Args: 
        NAME (str): unload this to .json file 
        CONFIG (str): remodel matlab to handle .json file as config instead of .csv?
        OUTPUTDIR (str): make path relative (for gear and docker purposes)
        DAT_FILE (str): full path to raw data recon file(s)
        NII_FILE (str): full path to siemens reconstructed reference .nii file(s)
        
        
```
        

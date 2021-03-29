#! /bin/bash
#
# Run DCE Recon Gear
# Built to flywheel-v0 spec.
#


CONTAINER="[sergeicu/dce_recon_gear]"
echo -e "$CONTAINER  Initiated"

# Configure the ENV
export MCRROOT=/opt/mcr/v96/
export LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64 ;
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64;
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64;

###############################################################################
# Configure paths

FLYWHEEL_BASE=/flywheel/v0
OUTPUT_DIR=$FLYWHEEL_BASE/output
INPUT_DIR=$FLYWHEEL_BASE/input
CONFIG_FILE=$FLYWHEEL_BASE/config.json
MANIFEST_FILE=$FLYWHEEL_BASE/manifest.json
DATFILE_DIR=$INPUT_DIR/datfile
NIIFILE_DIR=$INPUT_DIR/niifile

# Make the directories
WORK_DIR=/dce_recon
mkdir ${WORK_DIR}


###############################################################################
# Handle input files

DAT_FILE=$(find ${DATFILE_DIR} -type f -name "*.dat" | head -1)
NII_FILE=$(find ${NIIFILE_DIR} -type f -name "*.nii" | head -1)


# If we can't find it, we error out
if [[ -z "${NII_FILE}" ]]; then
  echo -e "$CONTAINER  No valid .nii files could be found!"
  exit 1
fi
if [[ -z "${DAT_FILE}" ]]; then
  echo -e "$CONTAINER  No valid .dat files could be found!"
  exit 1
fi


##############################################################################
# Parse configuration

function parse_config {
  CONFIG_FILE=$FLYWHEEL_BASE/config.json
  MANIFEST_FILE=$FLYWHEEL_BASE/manifest.json
  if [[ -f $CONFIG_FILE ]]; then
    echo -e "$(cat $CONFIG_FILE | jq -r '.config.'$1)"
  else
    CONFIG_FILE=$MANIFEST_FILE
    echo -e "$(cat $MANIFEST_FILE | jq -r '.config.'$1'.default')"
  fi
}

config_NAME="$(parse_config 'NAME')"
config_MRN="$(parse_config 'MRN')"
config_TIMEPOINTS="$(parse_config 'TIMEPOINTS')"

##############################################################################
# Run DCE RECON

echo -e "$CONTAINER  Starting dce_recon..."
cd $OUTPUT_DIR
run_dce_recon ${OUTPUT_DIR} "${DAT_FILE}" "${NII_FILE}" "${config_NAME}" "${config_MRN}" "${config_TIMEPOINTS}" 

# Check status code and die
if [[ $? != 0 ]]; then
  echo -e "$CONTAINER  Problem encountered during dce_recon"
  exit 1
fi


##############################################################################
# Get a list of the files in the output directory

outputs=$(find $OUTPUT_DIR/* -maxdepth 0 -type f )

# If outputs exist go home happy
if [[ -z $outputs ]]; then
  echo "$CONTAINER  FAILED: No results found in output directory... Exiting"
  exit 1
else
  # Set permissions for outputs (prevent root only r/w)
  chmod -R 777 $OUTPUT_DIR

  # End
  echo -e "$CONTAINER  Wrote: `ls ${OUTPUT_DIR}`"
  echo -e "$CONTAINER  Done!"
fi

exit 0

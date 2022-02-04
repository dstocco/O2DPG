#!/bin/bash

ddm="processing"
nodes="2"
wfName="raw-to-ctf"
optList="n:tw:"
while getopts $optList option; do
    case $option in
    n) nodes=$OPTARG ;;
    t) ddm="processing-disk" ;;
    w) wfName=$OPTARG ;;
    *)
        echo "Unimplemented option chosen $option."
        EXIT=1
        ;;
    esac
done

shift $((OPTIND - 1))

if [[ $EXIT -eq 1 ]]; then
    echo "Usage: $(basename "$0") (-$optList)"
    echo "       -n number of EPN nodes (default: $nodes)"
    echo "       -t write TF"
    echo "       -w workflow (default: $wfName)"
    exit 2
fi

function checkName() {
    wfNames=("raw-to-ctf-qc" "calib")
    for iwf in "${wfNames[@]}"; do
        if [[ "$1" = "$iwf" ]]; then
            return 0
        fi
    done
    echo "Unknown workflow $1"
    echo "Available: ${wfNames[*]}"
    return 1
}

checkName "$wfName" || exit 1

export GEN_TOPO_PARTITION=test # ECS Partition
export DDMODE=$ddm             # DataDistribution mode - possible options: processing, disk, processing-disk, discard

# Use these settings to fetch the Workflow Repository using a hash / tag
#export GEN_TOPO_HASH=1                                              # Fetch O2DataProcessing repository using a git hash
#export GEN_TOPO_SOURCE=v0.5                                         # Git hash to fetch

# Use these settings to specify a path to the workflow repository in your home dir
export GEN_TOPO_HASH=0                                # Specify path to O2DataProcessing repository
export GEN_TOPO_SOURCE=/home/dstocco/O2DataProcessing # Path to O2DataProcessing repository

export GEN_TOPO_LIBRARY_FILE=testing/detectors/MID/workflows.desc # Topology description library file to load
export GEN_TOPO_WORKFLOW_NAME="mid-${wfName}-workflow"            # Name of workflow in topology description library
export WORKFLOW_DETECTORS=ALL                                     # Optional parameter for the workflow: Detectors to run reconstruction for (comma-separated list)
export WORKFLOW_DETECTORS_QC=                                     # Optional parameter for the workflow: Detectors to run QC for
export WORKFLOW_DETECTORS_CALIB=                                  # Optional parameters for the workflow: Detectors to run calibration for
export WORKFLOW_DETECTORS_RECO=                                   # Optional parameters for the workflow: Detectors to run calibration for
export WORKFLOW_DETECTORS_FLP_PROCESSING=                         # Optional parameters for the workflow: Detectors to run calibration for
export WORKFLOW_PARAMETERS=                                       # Additional paramters for the workflow
export RECO_NUM_NODES_OVERRIDE="$nodes"                           # Override the number of EPN compute nodes to use (default is specified in description library file)
export NHBPERTF=128                                               # Number of HBF per TF
export MULTIPLICITY_FACTOR_RAWDECODERS=1                          # Factor to scale number of raw decoders with
export MULTIPLICITY_FACTOR_CTFENCODERS=1                          # Factor to scale number of CTF encoders with
export MULTIPLICITY_FACTOR_REST=1                                 # Factor to scale number of other processes with
export CTF_METAFILES_DIR="/data/epn2eos_tool/epn2eos"             # Directory where to store CTF files metada
export FILEWORKDIR="/home/dstocco/config"                         #FIXME: This is reset in gen_topo

export OUTPUT_FILE_NAME="$HOME/gen_topo_${wfName}-${RECO_NUM_NODES_OVERRIDE}.xml"

if /home/epn/pdp/gen_topo.sh >"$OUTPUT_FILE_NAME"; then
    echo Generated XML topology "$OUTPUT_FILE_NAME"
fi

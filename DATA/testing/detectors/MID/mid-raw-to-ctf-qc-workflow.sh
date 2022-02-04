#!/usr/bin/env bash

# shellcheck disable=SC1091
source testing/detectors/MID/mid_common.sh

eval "o2-dpl-raw-proxy $ARGS_ALL --dataspec \"$MID_RAW_PROXY_INSPEC\" --channel-config \"$MID_DPL_CHANNEL_CONFIG\" |
o2-mid-raw-to-digits-workflow $ARGS_ALL $MID_RAW_TO_DIGITS_OPTS |
o2-mid-entropy-encoder-workflow $ARGS_ALL |
o2-ctf-writer-workflow $ARGS_ALL $MID_CTF_WRITER_OPTS |
o2-qc $ARGS_ALL --config json://$FILEWORKDIR/mid-qcmn-epn-digits.json $MID_QC_EPN_OPTS |
o2-dpl-run $ARGS_ALL $GLOBALDPLOPT --dds"

#!/usr/bin/env bash

# shellcheck disable=SC1091
source testing/detectors/MID/mid_common.sh

eval "o2-dpl-raw-proxy $ARGS_ALL --dataspec $MID_RAW_PROXY_INSPEC --channel-config $MID_DPL_CHANNEL_CONFIG | 
o2-mid-raw-to-digits-workflow $ARGS_ALL $MID_RAW_TO_DIGITS_OPTS |
o2-mid-mask-maker-workflow $ARGS_ALL |
o2-dpl-run $ARGS_ALL $GLOBALDPLOPT --dds"

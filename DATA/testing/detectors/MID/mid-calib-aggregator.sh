#!/usr/bin/env bash

# shellcheck disable=SC1091
source testing/detectors/MID/mid_common.sh

eval "o2-dpl-raw-proxy $ARGS_ALL --dataspec \"$MID_CALIB_PROXY_INSPEC\" --proxy-name mid-noise-input-proxy --network-interface ib0 --channel-config \"$MID_CALIB_IN_CHANNEL_CONFIG\" |
o2-mid-mask-maker-workflow $ARGS_ALL |
o2-dpl-run $ARGS_ALL $GLOBALDPLOPT --dds"

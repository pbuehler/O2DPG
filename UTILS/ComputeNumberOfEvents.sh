#!/bin/bash

# parameters
TF=$1
IRATE=$2
OPTF=$3
SED=$4
NSIG=$5
NBKG=$6

# get the total number of events
NC=`${O2DPG_ROOT}/UTILS/getMaxNumberOfCollisions.sh ${TF} ${IRATE} ${OPTF} ${SED}`
if [ ${NC} -gt $((NSIG+NBKG)) ]
then
  NC=$((NSIG+NBKG))
fi

# randomly mix background and signal events with two constraints
# 1. the total number of events is NC
# 2. the ration of background to signal events is given by NBKG/NSIG
#  NBKGRND_TFx = NBKG * NC / (NSIG + NBKG)
#  NSIGNAL_TFx = NC - NBKGRND_TFx
#  EMBEDDPATTERN_TFx = bkg,IRATE,NBKGRND_TFx:NBKGRND_TFx sgn_x,SIR,NSIGNAL_TFx:NSIGNAL_TFx
# with SIR = IRATE * NSIGNAL_TFx / NBKGRND_TFx
let NB=$((${NBKG}*${NC}/(${NSIG}+${NBKG})))
let NS=$((${NC}-${NB}))

# export the variables
cmd='export NSIGNAL_TF'${TF}'='${NS}
eval ${cmd}
cmd='export NBKGRND_TF'${TF}'='${NB}
eval ${cmd}

# is embeddpattern required
if [ ${NB} -ge 0 ]
then
  if [ ${NS} -lt ${NB} ]
  then
    let SIR=$((${IRATE}*${NS}/${NB}))
    EP='"bkg,'${IRATE}','${NB}':'${NB}' sgn_'${TF}','${SIR}','${NS}':'${NS}'"'
  else
    let BIR=$((${IRATE}*${NB}/${NS}))
    EP='"bkg,'${BIR}','${NB}':'${NB}' sgn_'${TF}','${IRATE}','${NS}':'${NS}'"'
  fi
  cmd='export EMBEDDPATTERN_TF'${TF}'='${EP}
  eval ${cmd}
fi

# for debugging
cmd='echo "<ComputeNumberOfEvents> "${NSIGNAL_TF'${TF}'}" "${NBKGRND_TF'${TF}'}" "${EMBEDDPATTERN_TF'${TF}'}'
eval ${cmd}

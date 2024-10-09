#!/bin/bash

# parameters
TF=$1
IRATE=$2
OPTF=$3
SED=$4

# example
#TF=1
#IRATE=27208
#OPTF=32
#SED=504627853

# create maxsampCollisionsContext_x.root
NC=$(${O2_ROOT}/bin/o2-steer-colcontexttool -i sgn_1,${IRATE},${IRATE}:${IRATE} --orbitsPerTF ${OPTF} --orbits ${OPTF} --seed ${SED} -o dummyCollisionsContext_${TF}.root | grep INFO | tail -n 1 | awk '//{print $3}')
NC=$((NC+1))

# clean up
rm dummyCollisionsContext_1.root
echo $NC


# get the maximum number of collisions
# root -l
#auto context = o2::steer::DigitizationContext::loadFromFile(collcontextfile);
#auto collisionmap = context->getCollisionIndicesForSource(0);
#return collisionmap.size();

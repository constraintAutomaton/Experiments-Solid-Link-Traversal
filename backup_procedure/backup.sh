#!/bin/bash

today=`date "+%Y_%m_%d__%H_%M_%S"`
prefix=solidShapeIndexLTQP
source .env # don't forget to create an .env file with the variable cloudfolder='${my cloud folder with a write permission}'
experimentfolder=../experiments/*/output

tar -chzvf /tmp/$prefix-$today.tar.gz ${experimentfolder}
./cloudsend.sh /tmp/$prefix-$today.tar.gz  ${cloudfolder}
rm -rf /tmp/$prefix-$today.tar.gz
#!/bin/bash


rsync -avm --include='*/' --include='*.csv' --exclude='*' topaz:/group/director2188/sprint/frac_scale_test/ topaz/
rsync -avm --include='*/' --include='*.csv' --exclude='*' setonix:/scratch/director2188/sprint/frac_scale_test/ setonix/

if [ "$USER" == "llaniewski" ]
then
	rsync -avm --include='*/' --include='*.csv' --exclude='*' athena:/net/tscratch/people/plgllaniewski/frac_scale_test/ athena/
fi

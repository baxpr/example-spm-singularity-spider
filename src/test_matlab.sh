#!/bin/sh
#
# Test matlab in command line mode. We require the environment variable SPM_PATH 
# to contain the fully qualified path to the local SPM installation. I.e. before 
# running this script, execute
#    export SPM_PATH=/where/is/spm
# at the shell prompt.
matlab -nodisplay -nodesktop -nosplash -r \
    "addpath('${SPM_PATH}'); test_matlab; exit"

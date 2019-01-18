#!/bin/sh
#
# Of course we have to build or download the container .simg first.
#
# We use --cleanenv to avoid "polluting" our run with environment variables from 
# the host.
#
# We bind the locations of our test data to /INPUTS and /OUTPUTS in the 
# container.
#
# Path specifications for the inputs are relative to the container filesystem.

singularity \
run \
--cleanenv \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
baxpr-example-spm-singularity-spider-master-v1.0.0.simg \
t1_niigz /INPUTS/t1.nii.gz \
fmri_niigz /INPUTS/fmri.nii.gz \
fwhm 6 \
out_dir /OUTPUTS \
xnat_project TEST_PROJ \
xnat_subject TEST_SUBJ \
xnat_session TEST_SESS \
xnat_scan_t1 TEST_SCAN_T1 \
xnat_scan_fmri TEST_SCAN_FMRI

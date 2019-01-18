#!/bin/sh
#
# Test the compiled matlab. This runs on the compilation machine (linux).
sh run_example_main.sh /usr/local/MATLAB/MATLAB_Runtime/v92 \
t1_niigz ../INPUTS/t1.nii.gz \
fmri_niigz ../INPUTS/fmri.nii.gz \
fwhm 6 \
out_dir ../OUTPUTS \
xnat_project TEST_PROJ \
xnat_subject TEST_SUBJ \
xnat_session TEST_SESS \
xnat_scan_t1 TEST_SCAN_T1 \
xnat_scan_fmri TEST_SCAN_FMRI

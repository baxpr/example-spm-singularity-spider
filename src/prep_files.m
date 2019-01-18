function [t1_nii,fmri_nii] = prep_files(t1_niigz,fmri_niigz,out_dir)

copyfile(t1_niigz,fullfile(out_dir,'t1.nii.gz'));
gunzip(fullfile(out_dir,'t1.nii.gz'));
t1_nii = fullfile(out_dir,'t1.nii');

copyfile(fmri_niigz,fullfile(out_dir,'fmri.nii.gz'));
gunzip(fullfile(out_dir,'fmri.nii.gz'));
fmri_nii = fullfile(out_dir,'fmri.nii');

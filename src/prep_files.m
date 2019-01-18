function [t1_nii,fmri_nii] = prep_files(t1_niigz,fmri_niigz,out_dir)


copyfile(coregmat_file,[out_dir '/coregmat.txt']);
coregmat_file = [out_dir '/coregmat.txt'];

copyfile(wgm_file,[out_dir '/wgm.nii.gz']);
system(['gunzip -f ' out_dir '/wgm.nii.gz']);
wgm_file = [out_dir '/wgm.nii'];

copyfile(ct1_file,[out_dir '/ct1.nii.gz']);
system(['gunzip -f ' out_dir '/ct1.nii.gz']);
ct1_file = [out_dir '/ct1.nii'];

copyfile(wcseg_file,[out_dir '/wcseg.nii.gz']);
system(['gunzip -f ' out_dir '/wcseg.nii.gz']);
wcseg_file = [out_dir '/wcseg.nii'];

copyfile(deffwd_file,[out_dir '/y_deffwd.nii.gz']);
system(['gunzip -f ' out_dir '/y_deffwd.nii.gz']);
deffwd_file = [out_dir '/y_deffwd.nii'];

copyfile(func_file,[out_dir '/func.nii.gz']);
system(['gunzip -f ' out_dir '/func.nii.gz']);
func_file = [out_dir '/func.nii'];

copyfile(roi_file,[out_dir '/roi_labels.nii.gz']);
system(['gunzip -f ' out_dir '/roi_labels.nii.gz']);
roi_file = [out_dir '/roi_labels.nii'];


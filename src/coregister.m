function coregister(meanfmri_nii,t1_nii,fmri_nii)

% Coregister the mean fMRI to the T1. Update the headers of the existing
% mean fMRI and fMRI volumes in-place with the new orientation.

% Coregister mean fmri to T1
flags = struct( ...
	'sep',[4 2], ...
	'cost_fun','nmi', ...
	'tol',[0.02 0.02 0.02 0.001 0.001 0.001], ...
	'fwhm',[7 7] ...
	);
Vref = spm_vol(t1_nii);
Vsource = spm_vol(meanfmri_nii);
coreg_params = spm_coreg(Vref,Vsource,flags);
coreg_mat = spm_matrix(coreg_params(:)');

% Apply the coregistration to the fmri file by updating the matrix in the
% headers. We have to go volume by volume for the 4D nifti. We are re-using
% the filenames.
% 
% First the mean fmri
V = spm_vol(meanfmri_nii);
Y = spm_read_vols(V);
V.mat = coreg_mat \ V.mat;
spm_write_vol(V,Y);

% Then the the fMRI volumes. We expect the "Warning: Forcing deletion of
% MAT-file." for the first volume. It's ok because we have captured the
% info in the geometry .mat file with the first line here, and we are
% saving it back into the file.
V = spm_vol(fmri_nii);
for v = 1:length(V)
	Vout = V(v);
	Y = spm_read_vols(Vout);
	Vout.mat = coreg_mat \ Vout.mat;
	spm_write_vol(Vout,Y);
end

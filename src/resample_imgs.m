function [rfmri_nii] = resample_imgs(meanfmri_nii,fmri_nii)

% Resample all the fMRI volumes into the same voxel geometry. We use
% spm_reslice for this.
flags = struct( ...
        'mask',true, ...
        'mean',true, ...
        'interp',4, ...
        'which',1, ...
        'wrap',[0 0 0], ...
        'prefix','r' ...
        );
spm_reslice(char({meanfmri_nii;fmri_nii}),flags);

% Get filename for resliced 4D Nifti
[p,n,e] = fileparts(fmri_nii);
rfmri_nii = fullfile(p,['r' n e]);
function [srfmri_nii] = smooth_imgs(rfmri_nii,fwhm)

% Load the images
V = spm_vol(func_file);
Y = spm_read_vols(V);
sY = zeros(size(Y));

% Smooth
for v = 1:size(Y,4)
	tmp = Y(:,:,:,v);
	tmp2 = nan(size(tmp));
	spm_smooth(tmp,tmp2,params.spatialsmooth_fwhm);
	sY(:,:,:,v) = tmp2;
end

% Write to file
[p,n,e] = fileparts(func_file);
sfunc_file = fullfile(p,['s' n e]);
for v = 1:size(Y,4)
	Vout = V(v);
	Vout.fname = sfunc_file;
	Vout.n(1) = v;
	spm_write_vol(Vout,sY(:,:,:,v));
end

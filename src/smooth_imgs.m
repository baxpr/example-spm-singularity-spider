function [srfmri_nii] = smooth_imgs(rfmri_nii,fwhm)

% Load the images
V = spm_vol(rfmri_nii);
Y = spm_read_vols(V);
sY = zeros(size(Y));

% Smooth. To avoid batch mode, we write our own loop to do this with
% spm_smooth directly.
for v = 1:size(Y,4)
	tmp = Y(:,:,:,v);
	tmp2 = nan(size(tmp));
	spm_smooth(tmp,tmp2,str2double(fwhm));
	sY(:,:,:,v) = tmp2;
end

% Write to file. This is the general procedure for writing to a 4D nii with
% SPM functions. It has to go one volume at a time, and we have to be
% careful how we handle the scaling values in V.pinfo (they must be the
% same for all volumes). Here we are getting those from the original
% unsmoothed images.
%
% We also include the smoothing kernel size in the prefix of the smoothed
% image file, to provide a little extra information for whoever is using
% the files later.
[p,n,e] = fileparts(rfmri_nii);
srfmri_nii = fullfile(p,['s' fwhm '_' n e]);
for v = 1:size(Y,4)
	Vout = V(v);
	Vout.fname = srfmri_nii;
	Vout.n(1) = v;
	spm_write_vol(Vout,sY(:,:,:,v));
end


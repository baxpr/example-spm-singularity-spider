function [meanfmri_nii,rp_txt] = realignment(fmri_nii)

% SPM function call computes realignment params and updates headers
flags = struct( ...
	'quality',0.9, ...
	'sep',4, ...
	'fwhm',5, ...
	'rtm',1, ...
	'interp',2, ...
	'wrap',[0 0 0] ...
	);
spm_realign(fmri_nii,flags);

% Filename of realignment params
[fmri_p,fmri_n,fmri_e] = fileparts(fmri_nii);
rp_txt = fullfile(fmri_p,['rp_' fmri_n '.txt']);

% Now generate mean image via spm_reslice
flags = struct( ...
	'mask',true, ...
	'mean',true, ...
	'interp',4, ...
	'which',0, ...
	'wrap',[0 0 0], ...
	'prefix','r' ...
	);
spm_reslice(fmri_nii,flags);
meanfmri_nii = fullfile(fmri_p,['mean' fmri_n fmri_e]);


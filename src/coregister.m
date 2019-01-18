function coregister(meanfmri_nii,t1_nii,fmri_nii)

% Apply the initial transform to all funcs by updating the matrix in the
% headers. Seems we have to go volume by volume for the 4D nifti. We are
% re-using the filenames.
mat = load(coregmat_file);

V = spm_vol(meanradfunc_file);
Y = spm_read_vols(V);
V.mat = mat * V.mat;
spm_write_vol(V,Y);

V = spm_vol(radfunc_file);
for v = 1:length(V)
	Vout = V(v);
	Y = spm_read_vols(Vout);
	Vout.mat = mat * Vout.mat;
	spm_write_vol(Vout,Y);
end


% Coregister mean func to ct1
flags = struct( ...
	'sep',[4 2], ...
	'cost_fun','nmi', ...
	'tol',[0.02 0.02 0.02 0.001 0.001 0.001], ...
	'fwhm',[7 7] ...
	);
Vref = spm_vol(ct1_file);
Vsource = spm_vol(meanradfunc_file);
coreg_params = spm_coreg(Vref,Vsource,flags);
coreg_mat = spm_matrix(coreg_params(:)');


% Apply the coregistration to the func file headers (same procedure as
% above)
V = spm_vol(meanradfunc_file);
Y = spm_read_vols(V);
V.mat = coreg_mat \ V.mat;
spm_write_vol(V,Y);

% We expect the "Warning: Forcing deletion of MAT-file." for the first
% volume. It's ok because we have captured the info in the geometry .mat
% file with the first line here, and we are saving it back.
V = spm_vol(radfunc_file);
for v = 1:length(V)
	Vout = V(v);
	Y = spm_read_vols(Vout);
	Vout.mat = coreg_mat \ Vout.mat;
	spm_write_vol(Vout,Y);
end


% Filenames for coregistered images. We haven't changed them because we
% never did a reslice.
cradfunc_file = radfunc_file;
cmeanradfunc_file = meanradfunc_file;


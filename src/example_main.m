function example_main(varargin)

% This function example_main is the entry point to the matlab part of our
% spider. It takes a list of inputs, parses them, and calls the
% sub-functions for the various processing steps. We use matlab's varargin
% and inputParser methods to make this flexible and permit defaults for
% non-specified inputs.


%% Parse inputs

% Initialize the inputs structure
P = inputParser;

% Filepath for the T1 image. We will assume it's a compressed Nifti file,
% .nii.gz format. We'll use the default of '/INPUTS/T1.nii.gz' if this is
% not specified.
addOptional(P,'t1_niigz','/INPUTS/T1.nii.gz');

% Similar, for the fmri image set. Here we're expecting a single 4D nifti
% file.
addOptional(P,'fmri_niigz','/INPUTS/fmri.nii.gz');

% And we'll have the option to specify the size of the spatial smoothing
% kernel. Importantly, all inputs are passed in as strings when we call a
% compiled matlab function, which this will eventually be. So we expect a
% string here, and will need to handle it as such later on. Also the
% default value is specified here as a string '6' instead of a number 6.
addOptional(P,'fwhm','6');

% We need to know where to store our results. DAX/XNAT will look in a
% specific place to find them. Also, it's usually convenient to let this
% directory double as a working directory.
addOptional(P,'out_dir','/OUTPUTS');

% It's useful to pass in the project, subject, session, scan information
% when running on XNAT so that we can show it on the spider report.
addOptional(P,'xnat_project','UNK_PROJ');
addOptional(P,'xnat_subject','UNK_SUBJ');
addOptional(P,'xnat_session','UNK_SESS');
addOptional(P,'xnat_scan_t1','UNK_SCAN_T1');
addOptional(P,'xnat_scan_fmri','UNK_SCAN_FMRI');

% Parse the inputs and store each in its own variable for easier
% readability. Then report them back, which is useful for debugging spider
% failures on XNAT.
parse(P,varargin{:});

t1_niigz   = P.Results.t1_niigz;
fmri_niigz = P.Results.fmri_niigz;
fwhm       = P.Results.fwhm;
out_dir    = P.Results.out_dir;

xnat_project   = P.Results.xnat_project;
xnat_subject   = P.Results.xnat_subject;
xnat_session   = P.Results.xnat_session;
xnat_scan_t1   = P.Results.xnat_scan_t1;
xnat_scan_fmri = P.Results.xnat_scan_fmri;

fprintf('%s %s %s - T1 %s, fMRI %s\n', ...
	xnat_project,xnat_subject,xnat_session, ...
	xnat_scan_t1,xnat_scan_fmri);
fprintf('t1_niigz:   %s\n', t1_niigz   );
fprintf('fmri_niigz: %s\n', fmri_niigz );
fprintf('fwhm:       %s\n', fwhm      );
fprintf('out_dir:    %s\n', out_dir   );



%% Processing pipeline

% Prepare files. Nifti files are provided gzipped from XNAT, but SPM can
% only read unzipped ones. So it's useful to have an initial step that
% copies all the image files to a working directory and unzips them. In
% this case our working directory is also our output directory, and all new
% files that get created by the pipeline will therefore be there already
% without needing us to move them explicitly in the later steps.
[t1_nii,fmri_nii] = prep_files(t1_niigz,fmri_niigz,out_dir);

% FMRI realignment. SPM will update the headers of the fmri_nii file in
% place, and will produce the mean fMRI and the text file of realignment
% parameters that we capture here.
[meanfmri_nii,rp_txt] = realignment(fmri_nii);

% Coregister mean fMRI to T1, bringing the rest of the fMRI along for the
% ride. This updates the image headers in place rather than creating new
% files.
coregister(meanfmri_nii,t1_nii,fmri_nii);

% For this example pipeline, we will reslice/resample the images now in
% native space so it's possible to apply the smoothing kernel in the next
% step. More typically we would reduce interpolation error by saving this
% resampling step until the end after images have been warped to atlas
% space.
[rfmri_nii] = resample_imgs(meanfmri_nii,fmri_nii);

% Spatial smoothing.
[srfmri_nii] = smooth_imgs(rfmri_nii,fwhm);

% Make an output PDF. A PDF report is required for every spider that runs
% on XNAT.
[pdf_file] = make_pdf(t1_nii,meanfmri_nii,rp_txt,out_dir, ...
	xnat_project,xnat_subject,xnat_session,xnat_scan_t1,xnat_scan_fmri);

% Zip output images. Also required by XNAT.
[meanfmri_niigz,rfmri_niigz,srfmri_niigz] = zip_outputs( ...
	meanfmri_nii,rfmri_nii,srfmri_nii);



%% Finally, exit.
% This step should only run when deployed (i.e. when we are running the
% compiled version). But then it's necessary, to keep the matlab process
% from hanging forever after processing is finished.
if isdeployed, exit, end



function [pdf_file] = make_pdf(t1_nii,meanfmri_nii,rp_txt,out_dir, ...
	xnat_project,xnat_subject,xnat_session,xnat_scan_t1,xnat_scan_fmri)

% We'll use SPM functions to show the mean fmri. We make an invisible
% figure and print to PDF. Hopefully this works in combination with
% -nodisplay -nodesktop -nosplash command line options for the matlab call.
%
% This is pretty ugly because I threw it together fast. For a real spider,
% it's worth spending a little time to make a more thorough and informative
% report page (or multiple pages). Tools from ImageMagick can be useful to
% stitch together multiple PNGs or multiple pages.

% Initialize the figure
F = figure('visible','off');
colormap(gray);

% Show SPM's three-pane view
H = spm_orthviews('Image',meanfmri_nii,[],F);

% Make a two-line title string for the figure using a cell array
infostring = {[xnat_project ' ' xnat_subject ' ' xnat_session], ...
	['T1 ' xnat_scan_t1 ', fMRI ' xnat_scan_fmri]};

% Escape the _ so matlab doesn't interpret as subscript
infostring = strrep(infostring,'_','\_');

% Put the string onto the upper right panel of SPM's figure
A = get(F,'Children');
A(2).Title.String = infostring;

% Print to file
pdf_file = fullfile(out_dir,'report.pdf');
print(F,'-dpdf',pdf_file);


function [pdf_file] = make_pdf(t1_nii,meanfmri_nii,rp_txt,out_dir, ...
	xnat_project,xnat_subject,xnat_session,xnat_scan_t1,xnat_scan_fmri)

% We'll use SPM functions to show the mean fmri. We make an invisible
% figure and print to PDF. Hopefully this works in combination with
% -nodisplay -nodesktop -nosplash command line options for the matlab call.

F = figure('visible','off');

H = spm_orthviews('Image',meanfmri_nii,[],F);

infostring = [xnat_project ' ' xnat_subject ' ' xnat_session ': ' ...
	'T1 ' xnat_scan_t1 ', fMRI ' xnat_scan_fmri];
spm_orthviews('Caption',H,infostring);

pdf_file = fullfile(out_dir,'report.pdf');
print(F,'-dpdf',pdf_file);


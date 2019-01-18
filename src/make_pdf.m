function [pdf_file] = make_pdf(t1_nii,meanfmri_nii,rp_txt,out_dir, ...
	xnat_project,xnat_subject,xnat_session,xnat_scan_t1,xnat_scan_fmri)


system( [ ...
	'cd ' out_dir ' && ' ...
	magick_path '/convert ' ...
	'connectivity_removegm_noscrub.png ' ...
	'connmatrix_removegm_noscrub.png ' ...
	'connectivity_removegm_scrub.png ' ...
	'connmatrix_removegm_scrub.png ' ...
	'connectivity_keepgm_noscrub.png ' ...
	'connmatrix_keepgm_noscrub.png ' ...
	'connectivity_keepgm_scrub.png ' ...
	'connmatrix_keepgm_scrub.png ' ...
	'coreg_check.png ' ...
	'fmri_conncalc.pdf' ...
	] );

# Example singularity spider with SPM/Matlab

This document walks through the process of creating an SPM-based container that 
implements realignment, coregistration, and smoothing for an fMRI data set. 

# File list

    bin/
	  example_main               Compiled Matlab executable
	  run_example_main.sh        Matlab's generated runscript for the executable
	  test_compiled_matlab.sh    Test the compiled executable
	  <others>                   Other stuff that Matlab compiler leaves around
	src/
	  example_main.m             Main matlab function - pipeline entrypoint
	  prep_spm_for_compile.m     We need to tweak our SPM installation to compile
	  test_matlab.m              Test the code at the Matlab command line
	  test_matlab.sh             Test the code at the shell command line
	  <others>                   Subfunctions for different parts of the pipeline
	.gitattributes               Tracks files for git-lfs
	.gitignore                   Use this to keep some things (test data) out of the repo
	README.md                    This file
	compile_matlab.sh            Shell script to compile the matlab code


# The process

## Develop and test the Matlab code locally
Matlab code is in the `src` directory. Included is a matlab function to test 
it, `src/test_matlab.m`. Once that works within the Matlab IDE, the next step 
is to verify the command line operation with `src/test_matlab.sh`. Only at that 
point is it worth proceeding to compilation.

A critical point here is that there is a single entrypoint for the processing. In this case it's the function `example_main.m` which takes file paths and parameters as input and calls the various parts of the pipeline. All outputs should be stored in the `out_dir` that is specified when this function is called. That may also be used as a working directory. In a container, the accessible directories and files will not match the development systems, so some attention needs to be paid to where things are.


## Compile the Matlab code and test
See `compile_matlab.sh`. There is a test script for the compiled code as well: 
`bin/test_compiled_matlab.sh`. Once it is working correctly, proceed to 
building the container.

The compiled matlab executable will often exceed github's 100 MB file size limit. In that case, [git LFS](https://git-lfs.github.com/) is useful:

    git lfs track bin/example_main


## Build the container and test

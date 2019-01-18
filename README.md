# Example singularity spider with SPM/Matlab

This document walks through the process of creating an SPM-based container that 
implements realignment, coregistration, and smoothing for an fMRI data set. 

# The process

## Develop and test the Matlab code locally
Matlab code is in the `src` directory. Included is a matlab function to test 
it, `src/test_matlab.m`. Once that works within the Matlab IDE, the next step 
is to verify the command line operation with `src/test_matlab.sh`. Only at that 
point is it worth proceeding to compilation.

## Compile the Matlab code and test
See `compile_matlab.sh`. There is a test script for the compiled code as well: 
`bin/test_compiled_matlab.sh`. Once it is working correctly, procede to 
building the container.

The compiled matlab executable will often exceed github's 100 MB file size limit. In that case, git LFS is useful:

    git lfs track bin/example_main

[Installation instructions for git-lfs](https://git-lfs.github.com/)

## Build the container and test

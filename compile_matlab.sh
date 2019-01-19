#!/bin/sh
#
# Compile the matlab code so we can run it without a matlab license. To create a 
# linux container, we need to compile on a linux machine. That means a VM, if we 
# are working on OS X.
#
# We require on our compilation machine:
#     Matlab 2017a, including compiler, with license
#     Installation of SPM12, https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
#
# The matlab version matters. If we compile with R2017a, it will only run under 
# the R2017a Runtime.

# Where to find SPM12 on our compilation machine
SPM_PATH=/opt/spm12

# We may need to add Matlab to the path on the compilation machine
export PATH=/usr/local/MATLAB/R2017a/bin:${PATH}

# For the compiler to find all SPM dependencies, we need to do some stuff from 
# spm_make_standalone.m in our SPM installation. This only needs to be done once
# for a given installation, but it won't make changes if it finds it has already
# run.
matlab -nodisplay -nodesktop -nosplash -sd src -r \
    "prep_spm_for_compile('${SPM_PATH}'); exit"

# Run the matlab compiler from the linux command line instead of from within a
# Matlab session - it's easier to get the correct punctuation that way.
#
# We need to -I include the root spm directory and the paths that SPM needs - 
# the paths it auto-adds to the matlab path when you run it interactively: 
# config, matlabbatch, matlabbatch/cfg_basicio
#
# We need to -a add SPM's Contents.txt file (produced by prep_spm_for_compile.m)
# so it can find its version number.
#
# We need to -a add non-code image and template files in some SPM directories:
#    canonical, EEGtemplates, toolbox, tpm
#
# Some spiders (not this example) will have other non-code files that Matlab 
# compiler won't find on its own, e.g. .fig files, .csv, etc. These can be 
# explicitly included here with the -a flag as well. If they are missing, the 
# code will compile just fine but will fail at runtime.
#
# If there are other directories with additional code in them, they will need to 
# be added here with the -I flag.
#
# The compiled binary will be put in the bin directory.
#
# It's usually fine to ignore compiler warnings about the fixedpoint toolbox.
mkdir -p bin
mcc -m -v src/example_main.m \
-I ${SPM_PATH} \
-I ${SPM_PATH}/config \
-I ${SPM_PATH}/matlabbatch \
-I ${SPM_PATH}/matlabbatch/cfg_basicio \
-a ${SPM_PATH}/Contents.txt \
-a ${SPM_PATH}/canonical \
-a ${SPM_PATH}/EEGtemplates \
-a ${SPM_PATH}/toolbox \
-a ${SPM_PATH}/tpm \
-d bin

# We grant lenient execute permissions to the matlab executable and runscript so
# we don't have hiccups later.
chmod go+rx bin/example_main
chmod go+rx bin/run_example_main.sh


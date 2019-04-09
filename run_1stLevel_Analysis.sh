#!/bin/bash

# Set the directory that contains the data folders
# We use the $USER variable so that this script can be run
#     unmodified by any user

# dataDir=/nfs/test/ds102
# scriptDir=/nfs/test/scripts
dataDir=/nfs/turbo/nii-open/psych808-w19/bennet/ds102
scriptDir=/nfs/turbo/nii-open/psych808-w19/bennet/scripts

# Change to the data directory
cd $dataDir

# Generate the subject list.  Do it this way to make modifying this script
# to run just a subset of subjects easier.  Otherwise we might end up with
# a bunch of feat+ directories.

# Running just the first subject
# Change the numbers inside the {} to be the subjects to be processed.
for id in {01..01} ; do
    subj="sub-$id"
    echo "===> Starting processing of $subj"
    echo
    cd $subj

        # If the brain mask doesn’t exist, create it
        if [ ! -f anat/${subj}_T1w_brain.nii.gz ]; then
            bet anat/${subj}_T1w.nii.gz \
                anat/${subj}_T1w_brain.nii.gz # Note: changed from bet2
        fi
    
        # Copy the design files into the subject directory, and then
        # change “sub-01” to the current subject number
        cp $scriptDir/design_run1.fsf .

        # Note that we are using the | character to delimit the patterns
        # instead of the usual / character because there are / characters
        # in the pattern.  This is a handy trick; remember it; you may
        # use it again; and again.
        sed -i "s|DS102DATADIR|${dataDir}|g ; s|sub-01|${subj}|g" \
            design_run1.fsf

        # Now everything is set up to run feat
        echo "===> Starting feat for run 1"
        feat design_run1.fsf
        echo

    cd $dataDir
done
echo

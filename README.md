# iMARA

Collection of MATLAB code for running automatic classification of ICA components from infant EEG data.

See Haresign, I. M., Phillips, E., Whitehorn, M., Noreika, V., Jones, E., Leong, V., & Wass, S. V. (2021). Automatic classification of ICA components from infant EEG using MARA. bioRxiv.

See also Winkler, I., Haufe, S., & Tangermann, M. (2011). Automatic classification of artifactual ICA-components for artifact removal in EEG signals. Behavioral and Brain Functions, 7(1), 1-15.


To run the function you only need to call the main function (iMARA) – all the other functions are to do with calculating the features of the data used in classification.

The dataset must be in the EEGLAB structure and you must have run ICA

For the most basic implementation just call it as --- [rejected_componenets,~] = iMARA(EEG)


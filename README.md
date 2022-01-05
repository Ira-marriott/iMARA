# iMARA

Collection of MATLAB code for running automatic classification of ICA components from infant EEG data.

See Haresign, I. M., Phillips, E., Whitehorn, M., Noreika, V., Jones, E., Leong, V., & Wass, S. V. (2021). Automatic classification of ICA components from infant EEG using MARA. https://doi.org/10.1016/j.dcn.2021.101024

See also Winkler, I., Haufe, S., & Tangermann, M. (2011). Automatic classification of artifactual ICA-components for artifact removal in EEG signals. Behavioral and Brain Functions, 7(1), 1-15.


RUNNING THE FUNCTION

For the most basic implementation call the main function iMARA.m - use as

components_to_reject = iMARA(EEG)

This will return a list of the components that the iMARA systems has identified as containing artifact/ recommends to be removed.

This function is built to accept EEG data in the EEGLAB (structure) format. 

Note this system is built around 32 channel infant data recorded using Biosemi equipment. Classification of ICA components is in part based on the topographical features of the component and therefore it is important that the channel information entered into the function follows the same layout 32 channel 10-20 layout. https://cortechsolutions.com/biosemi-32-channel-head-cap-layout/. 

The input dataset must be in the EEGLAB structure and you must have run ICA

MORE ADVANCED IMPLEMENTATIONS

For most user this basic implementation will be sufficient however some users may wish to change the threshold for rejection. This can be done by adding a second input value - which indicates the desired rejection threshold, e.g.,

new_threshold = 0.5=6;

components_to_reject = iMARA(EEG, new_threshold)

Threshold values must range from 0 to 1

The threshold indicates how certain the classifer is that a component contains neural activity. For example a threshold of 0.6 indicates that all components that were classified with a less that 60% likelihood of containing neural activity are marked for rejection.


For any issues with the code or with implementing the function please contact Ira Marriott - u1434978@uel.ac.uk







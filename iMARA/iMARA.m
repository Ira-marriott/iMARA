function [g,info] = iMARA(EEG,art_threshold)


%  This code accompanies the paper "Automatic classification of ICA components from infant EEG using MARA"

% ref Marriott Haresign, Phillips, Whitehorn, Noreika, Jones, Leong & Wass, 2021
% contact u1434978@uel.ac.uk

% function for automatically sorting ICA-components from infant EEG data

% call as --- [rejected_componenets,~] = iMARA(EEG)

% input is EEG data
% EEG data must be within EEGlab structure and you must have already run
% ICA see here https://sccn.ucsd.edu/wiki/Chapter_09:_Decomposing_Data_Using_ICA

% art_threshold is optional - setas the threshold for probability than
% component will be taken as artefact. Deafult is set at 0.9

% output g is index of components that the classifier has marked as non
% neural/ artefact

% info is a list of each components score for the six features described in the accompanying paper e.g 
% Haresign, I. M., Phillips, E., Whitehorn, M., Noreika, V., Jones, E., Leong, V., & Wass, S. V. (2021). Automatic classification of ICA components from infant EEG using MARA. bioRxiv.

% much of this code is adapted from code that was written by 
% Winkler, I., Haufe, S., & Tangermann, M. (2011). Automatic classification of artifactual ICA-components for artifact removal in EEG signals. Behavioral and Brain Functions, 7(1), 1-15.


%% 

 if ~exist('art_threshold','var');art_threshold = 0.9; end

% new infant training data stored as...
load ('training_mat2','fv_tr');

% adjust channel to fit 32 channel biosemi recordings
clab = {EEG.chanlocs.labels};
clab(7) = {'T7'};
clab(24) = {'T8'};

    % cut to channel labels common with training data 
    [clab_common, i_te, i_tr ] = intersect(upper(clab), upper(fv_tr.clab));%load struct fv_tr   
       
    patterns = (EEG.icawinv(i_te,:));
    [M100, idx] = get_M100_ADE(clab_common); %needed for Current Density Norm

    disp('iMARA is computing features. Please wait');
    %standardize patterns
    patterns = patterns./repmat(std(patterns,0,1),length(patterns(:,1)),1);

    %compute current density norm
    feats(1,:) = log(sqrt(sum((M100*patterns(idx,:)).^2)));
   
    %compute spatial range
    feats(2,:) = log(max(patterns) - min(patterns));

     %Average Local Skewness, Band Power 6 -9 Hz) 
    feats(3:6,:) = extract_time_freq_features2(EEG);
    
    disp('Features ready');

    %%  Adapt train features to clab 
    %%%%%%%%%%%%%%%%%%%%
    
% if any features have scored nan remove - but should work out why this is happening    
if any(isnan(feats))
      feats(~any(~isnan(feats), 2),:)=zeros(1,length(feats));
end

% this is neccessary as indexing for orignal i_tr i based of match with 104
% chan montage
loc_labels = fv_tr.clab(i_tr);
temp = zeros(1,length(loc_labels));
i = contains(loc_labels, clab(7)); loc_labels(i) = {EEG.chanlocs(7).labels};
j = contains(loc_labels, clab(24)); loc_labels(j) = {EEG.chanlocs(24).labels};


for fi=1:length(loc_labels)
    temp(fi) = getchanloc(loc_labels(fi));
end

i_tr=temp;


     fv_tr.pattern = fv_tr.pattern(i_tr, :);
     fv_tr.pattern = fv_tr.pattern./repmat(std(fv_tr.pattern,0,1),length(fv_tr.pattern(:,1)),1);
     fv_tr.x(2,:) = log(max(fv_tr.pattern) - min(fv_tr.pattern));
     fv_tr.x(1,:) = log(sqrt(sum((M100 * fv_tr.pattern).^2))); 


     [~, ~, posterior] = classify(feats',fv_tr.x',fv_tr.labels);
 
     info.posterior_artefactprob = posterior(:, 1)'; 
     info.normfeats = (feats - repmat(mean(fv_tr.x, 2), 1, size(feats, 2)))./ repmat(std(fv_tr.x,0, 2), 1, size(feats, 2)); 


     g = find(info.posterior_artefactprob<art_threshold);
%      if probability of comoponent being artefact is greater than 0.9 then
%      the classfier marks as neural if less than 0.9 marks as artefact
%      other studies may wish to change these cutoffs
                     
                
                return
                

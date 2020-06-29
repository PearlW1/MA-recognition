
function [fpi, per_lesion_sensitivity] = froc(scores_maps, gt_labels, show_fig)

    if exist('show_fig','var')==0
        show_fig = true;
    end

    % Sort the scores
    thresholds = sort(unique(scores_maps(:,3)));
    clear all_scores

    if (length(thresholds) > 1)
        
        % initialize matrices with tp lesions, n lesions and fp candidates
        tps_lesions = zeros(1, length(thresholds));
        ns_lesions = zeros(1, 1);%%groundtruth 的个数
        fps_candidates = zeros(1, length(thresholds));
        
        fprintf('Computing FROC curve\n');
        % for each score map
        for j = 1 : 1
            fprintf('.');
            current_score = scores_maps(:,3);
            ground_truth = gt_labels > 0;           
            % for each threshold value
            for i = 1 : length(thresholds)
                current_count=0;
                % segment using the given threshold
                current_segmentation = current_score > thresholds(i);
                if max(current_segmentation)==0
                    break;
                else
                    indx=find(current_segmentation);
                    for ii=1:1:size(indx,1)
                       x=scores_maps(indx(ii),1);
                       y=scores_maps(indx(ii),2);
                       for jj=1:1:size(gt_labels,1)
                           X=gt_labels(jj,1);
                           Y=gt_labels(jj,2);
                           d=sqrt((x-X)*(x-X)+(y-Y)*(y-Y));
                           if d<=10
                               current_count=current_count+1;
                               break;
                           end
                       end
                    end
                    tps_lesions(j,i)=current_count;
                    fps_candidates(j,i)=size(indx,1)-current_count;
                end
             end               
                % tp lesions will be all the lesions that were detected
% %                 tps_lesions(j,i) = length(unique(ground_truth_labeled(true_intersection)));
                % fp will be all the candidates that are not inside a red
                % lesion region
%                 [candidates_labeled, n_candidates] = bwlabel(current_segmentation);
%                 fps_candidates(j,i) = size(scores_maps,1) - length(find(tps_lesions)==1);


        fprintf('\n');
        ns_lesions=size(gt_labels,1);
        % per lesion sensitivity
        per_lesion_sensitivity = sum(tps_lesions, 1) / sum(ns_lesions);
        % false positives per image
        fpi = mean(fps_candidates, 1);%%每一列求均值

        % FPI references according to Niemeijer et al., TMI 2009
        fpi_references = [1/8, 1/4, 1/2, 1, 2, 4, 8];

        % sort FPI and per lesion sensitivities
        [sorted_fpi, idxs] = sort(fpi);%%又给每一列均值排序
        sorted_per_lesion_sensitivity = per_lesion_sensitivity(idxs);%%找出与fpi'对应的per_lesion_sensitivity
%         % retrieve unique FPIs
%         [u_sorted_fpi,index] = unique(sorted_fpi,'first');
%         u_sorted_per_lesion_sensitivity = sorted_per_lesion_sensitivity(index);
%         
%         
%         non_zero_idxs = (u_sorted_fpi~=0);
%         u_sorted_fpi = u_sorted_fpi(non_zero_idxs);
%         u_sorted_per_lesion_sensitivity = u_sorted_per_lesion_sensitivity(non_zero_idxs);
%         
%         values_to_complete = fpi_references(logical(ones(1, length(fpi_references)) - (min(u_sorted_fpi) < fpi_references)));
%         u_sorted_fpi = cat(2, values_to_complete, u_sorted_fpi); 
%         u_sorted_per_lesion_sensitivity = cat(2, zeros(size(values_to_complete)), u_sorted_per_lesion_sensitivity);
%         
%         
%         % interpolate values
%         reference_se_vals = interp1(u_sorted_fpi, u_sorted_per_lesion_sensitivity, fpi_references, 'spline') ;
%         reference_se_vals(reference_se_vals<0) = 0;
%         
%         % Now, take the mean of those values as the FROC score
%         froc_score = mean(reference_se_vals);

        % if show_fig, show the plot
%         if (show_fig)
%             plot_froc(per_lesion_sensitivity, fpi);
%         end
%         
%     else
%         
%         fpi = [];
%         per_lesion_sensitivity = [];
%         froc_score = 0;
%         
    end

end


function [V,C,err,it] = k_means(Elements,n_Clusters,delta,iter)
    %Variables
    N = size(Elements,2); % number of elements
    f = size(Elements,1); % number of features
    clusters = ones(f,1)*rand(1,n_Clusters); % Clusters initialization
    new_clusters = zeros(f,n_Clusters); % New Clusters initialization
    labels = (1:n_Clusters);
    label_E = zeros(1,N); % Vector of element labels
    diff_clusters = 10; % Initialization diff clusters
    it = 0; % Iterations counter
    % Number of iterations
    while ((diff_clusters>delta)&&(it<iter))
        % Label indexing for each element
        for element=1:N
            dist = Elements(:,element)-clusters;
            [~,min_index] = min(vecnorm(dist));
            label_E(element) = labels(min_index);
        end
        % Calculating new clusters
        err = zeros(1,n_Clusters); % Vector to save distances of elements to its cluster
        p = zeros(1,n_Clusters); % Vector of probability of clusters
        for label=1:n_Clusters
            X = Elements(:,label_E==label);
            if (~isempty(X))
                new_clusters(:,label) = mean(X,2); % New clusters
                err(:,label) = sum(vecnorm(X - mean(X,2))); % Distance clusters and labeled data
            end
        end
        % Error consecutive clusters
        diff = abs(clusters - new_clusters);
        diff = (diff(~isnan(diff))); % Verifying NaN clusters
        diff_clusters = norm(vecnorm(diff));
        % New clusters assigment
        clusters = new_clusters;
        it = it + 1; % Increase iteration counter
    end
    % Outputs
    V = label_E; % Vector of final elements labels
    C = clusters; % Vector of final clusters
end
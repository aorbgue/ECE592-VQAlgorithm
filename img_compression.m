function [img_out,V] = img_compression(img_in,P,R,Type)
    M = size(img_in,1);
    N = size(img_in,2);
    img_data = zeros(P^2,M*N/P^2); % Vector of elements
    img_out = zeros(M,N); % Image quantized
    % Partition Image into vector of elements for clustering algorithm
    for dy=1:N/P
        for dx=1:M/P
            sub_img = img_in(P*dx-P+1:P*dx,P*dy-P+1:P*dy);
            img_data(:,(dx+(dy-1)*M/P)) = reshape(sub_img,P^2,1);
        end
    end
    % Clustering Type=0 (Custom), Type=1 (MATLAB)
    if (Type==0)
        delta = 0.01; % Stop condition between to consecutive kernels
        iter = 20;
        [V,C]=k_means(img_data/255.0,round(2^(R*P^2)),delta,iter);
    elseif (Type==1)
        [V,C]=kmeans(img_data'/255.0,round(2^(R*P^2)));
        V = V';
        C = C';
    end
    % Image reconstruction
    img_vector = uint8(C(:,V)*255);
    % Image reconstruction from vector elements
    for dy=1:N/P
        for dx=1:M/P
            sub_vec = img_vector(:,(dx+(dy-1)*M/P));
            img_out(P*dx-P+1:P*dx,P*dy-P+1:P*dy)= reshape(sub_vec,P,P);
        end
    end
    img_out = uint8(img_out);
end
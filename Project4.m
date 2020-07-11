%% Project 4
%% --- 1) Load Image and resize
img_name = 'Landscape.png';
img = rgb2gray(imread(img_name)); % Convert to gray scale
M = 2048; % length M
N = 4096; % length N
img = img(1:M,1:N); % Image Resized
Type = 0; % Type kmeans used 0=custom, 1=MATLAB
%% --- 2) Clustering and vector quantization
R = 1; % Rate
P = 2; % Pixels per patch (must be power of 2)
img_Q = img_compression(img,P,R,Type);
figure(1)
imshow(img)
figure(2)
imshow(img_Q)
imwrite(img,'Landscape_Gray.png')
imwrite(img_Q,'Landscape_Q.png')
%% --- 3) Rate vs Distortion and 4) Patch Size and 5) Better Compression
P = [2,4,8,16]; % Patch {2,4,8,16}
Num = 6; % It is generated 5 rates per Patch
R = zeros(length(P),Num); % Rate matrix
D = zeros(length(P),Num); % Distortion matrix
R_norm = zeros(length(P),Num); % Normalized Rate matrix
% Generating rates for each patch P
maxR = log2(sqrt(M*N./P.^2))./P.^2; % Maximum rates
maxR(maxR>=1)=1; % No rate greater than 1
minR = ones(1,length(P))./P.^2; % Minimum rates
for i =1:length(P)
    R(i,:) = linspace(minR(i),maxR(i),Num);
end
% Distortion vs Rate and Normalized Rate calculation
for i = 1:length(P)
    for j=1:length(R)
        [img_Q ,V] = img_compression(img,P(i),R(i,j),Type);
        D(i,j) = sum((img_Q-img).^2,'all')/(M*N);
        %Entropy and Rate Calculation
        H = 0; % Entropy
        n_C = round(2^(R(i,j)*P(i)^2)); % Number of clusters
        for k=1:n_C
            p = sum(V==k)/length(V); % Probability
            if(p~=0) % Verifying if cluster exists (p>0)
                H = H - p*log2(p); % Entropy
            end
        end
        R_norm(i,j) = H/P(i)^2; % Normalized Rate
        % Progress
        c = fix(clock);
        fprintf('Progress: %d of %d ',((i-1)*length(R)+j),length(R)*length(P));
        fprintf('Time: %d:%d:%d \n',c(4),c(5),c(6));
    end
    % Save img with highest Rate
    imwrite(img_Q,strcat('Landscape_Q_P_',num2str(P(i)),'.png'));
end
r_p = (1-R_norm./R)*100; % Reduction Coding Rate calculation (%)
%% PLOTS
% Plot Rate vs Distortion for P=2
figure(3)
plot(R(1,:),D(1,:))
title('Distortion vs Rate P=2')
xlabel('Rate')
ylabel('Distortion')
% Plot Rate vs Distortion for P=2,4,8,16
figure(4)
for i=1:length(P)
    plot(R(i,:),D(i,:))
    hold on
end
title('Distortion vs Rate')
xlabel('Rate')
ylabel('Distortion')
legend('P=2','P=4','P=8','P=16')
figure(5)
for i=1:length(P)
    plot((1:Num),D(i,:))
    hold on
end
title('Distortion vs Rate')
xlabel('Rate Index')
ylabel('Distortion')
legend('P=2','P=4','P=8','P=16')
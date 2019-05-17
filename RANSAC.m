% This function receives the SIFT Features and Descriptors (k1,k2)
% and the Match local descriptors (Matches) and solves for the 
% best homography matrix using Random sample consensus algorithm
% (RANSAC)

% RANSAC algorithm
% 1- Select four feature pairs (at random)
% 2- Compute homography H (exact)
% 3- Compute inliers 
% 4- Keep largest set of inliers
% 5- e-compute least-squares H estimate using all of the inliers

% k1,k2 -->SIFT Features and Descriptors
% matches -->Match local descriptors
% bestH -->Bet homography matrix
% maxInliers -->number of inliers for the best homography matrix
function [bestH, maxInliers] = RANSAC (k1,k2,matches)

numMatches = size(matches,2);
pixelError = 6;  % error chosen to calculate inliers 

numIters = 100;
numPts = 4;

A = zeros(2 * numPts, 8);
b = zeros(2 * numPts, 1);

bestH = zeros(3,3);
maxInliers = -Inf;

for ind = 1 : numIters
    % choose four random points.. 
    randSample = randperm(numMatches, numPts);
    % this returns a row vector cnontaining numpts unique integers 
    % selected randomly from 1 to numMatches
    
    % calculating homography matrix
    i = 1;
    for j = 1 : numPts
        % get random match point
        matchInd = randSample(j);
        % get its indeces
        d1 = matches(1, matchInd);
        d2  = matches(2, matchInd);
        % get x and y coordinates of the random matches from the SIFT
        % features
        X1 = k1(1, d1); Y1 = k1(2, d1);
        X2  = k2(1, d2); Y2  = k2(2, d2);
        
        A(i, :) = [X1 Y1 1 0 0 0 -X1*X2 -Y1*X2];
        b(i) = X2;
        i = i + 1;
        
        A(i, :) = [0 0 0 X1 Y1 1 -X1*Y2 -Y1*Y2];
        b(i) = Y2;
        i = i + 1; 
        
        i = i + 1; 
    end
    
    x = A\b;
    
    homography = [x(1) x(2) x(3); x(4) x(5) x(6); x(7) x(8) 1];
    Inliers = 0;

    % finnding number of inliers 
    % numMatches equals total number of matching points
    for matchIndex = 1:numMatches
        d1 = matches(1, matchIndex);
        d2  = matches(2, matchIndex);
        
        X1 = k1(1, d1); Y1 = k1(2, d1);
        X2  = k2(1, d2); Y2  = k2(2, d2);
    
        P1 = [X1; Y1; 1];
        P2  = [X2; Y2; 1];
        
        P11 = homography*P1;
        % then normalize p11
        P11 = P11 ./ P11(3);
        err = norm((P11 - P2),2);
        if err <= pixelError
            Inliers = Inliers + 1;
        end
    end
    if Inliers > maxInliers
       maxInliers = Inliers;
       bestH = homography;
    end
end


function [ class, centroid ] = mykmeans( pixels, K )
%
% Your goal of this assignment is implementing your own K-means.
%
% Input:
%     pixels: data set. Each row contains one data point. For image
%     dataset, it contains 3 columns, each column corresponding to Red,
%     Green, and Blue component.
%
%     K: the number of desired clusters. Too high value of K may result in
%     empty cluster error. Then, you need to reduce it.
%
% Output:
%     class: the class assignment of each data point in pixels. The
%     assignment should be 1, 2, 3, etc. For K = 5, for example, each cell
%     of class should be either 1, 2, 3, 4, or 5. The output should be a
%     column vector with size(pixels, 1) elements.
%
%     centroid: the location of K centroids in your result. With images,
%     each centroid corresponds to the representative color of each
%     cluster. The output should be a matrix with size(pixels, 1) rows and
%     3 columns. The range of values should be [0, 255].
%     
%
% You may run the following line, then you can see what should be done.
% For submission, you need to code your own implementation without using
% the kmeans matlab function directly. That is, you need to comment it out.

	%[class, centroid] = kmeans(pixels, K);

    nPoints = size(pixels, 1);
    dim = size(pixels, 2);
    emptyCluster = false;
    totalDistPrev = inf;
    class = zeros(nPoints, 1);
    classPrev = class;
    classPrev2 = class;
    while 1
        if emptyCluster == true
            if K >= 1
                K = floor(K/2);
            end
            emptyCluster = false;
        end
        randIndex = randperm(nPoints, K);
        centroid = pixels(randIndex, :);
        noChange = false;
        while noChange == false
            totalDist = 0;
            for p = 1:nPoints
                dist = zeros(1, K);
                for c = 1:K
                    dist(c) = norm(pixels(p, :)-centroid(c, :));
                end
                [d, class(p)] = min(dist);
                totalDist = totalDist + d;
            end
            for c = 1:K
                if isempty(find(class, c))
                    emptyCluster = true;
                    break;
                end
                centroid(c, :) = mean(pixels(class == c, :), 1);
            end
            if emptyCluster == true
                break;
            end
            if isequal(class, classPrev2)
                noChange = true;
            end
            classPrev2 = class;
        end
        if (totalDist >= totalDistPrev)
            centroid = centroidPrev;
            class = classPrev;
            break;
        end
        centroidPrev = centroid;
        classPrev = class;
        totalDistPrev = totalDist;
    end
    
end


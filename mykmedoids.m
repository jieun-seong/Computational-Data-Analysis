function [ class, medoid ] = mykmedoids( pixels, K )
%
% Your goal of this assignment is implementing your own K-medoids.
% Please refer to the instructions carefully, and we encourage you to
% consult with other resources about this algorithm on the web.
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

    nPoints = size(pixels, 1);
    dim = size(pixels, 2);

    emptyCluster = false;
    stop = false;

    totalDistPrev = inf;
    class = zeros(nPoints, 1);
    classPrev = zeros(nPoints, 1);

    while stop == false
        if emptyCluster == true
            if K >= 1
                K = floor(K/2);
            end
            emptyCluster = false;
        end
        randIndex = randperm(nPoints, K);
        medoid = pixels(randIndex, :);
        centroid = pixels(randIndex, :);
        noChange = false;
        while noChange == false
            classPrev2 = class;
            totalDist = 0;
            for p = 1:nPoints
                dist = zeros(1, K);
                for c = 1:K
                    dist(c) = norm(pixels(p, :)-medoid(c, :));
                end
                [d, class(p)] = min(dist);
                totalDist = totalDist + d;
            end
            for c = 1:K
                centroid(c, :) = mean(pixels(class == c, :), 1);
                dist(class == c) = vecnorm(pixels(class == c, :) - centroid(c, :), 2, 2);
                indexC = find(class==c);
                if isempty(indexC)
                    emptyCluster = true;
                    break;
                end
                [~, indexMin] = min(dist(class==c));
                medoid(c, :) = pixels(indexC(indexMin), :);
            end
            if emptyCluster == true
                break;
            end
            if class == classPrev2
                noChange = true;
            end
        end
        if (totalDist >= totalDistPrev)
            centroid = centroidPrev;
            medoid = medoidPrev;
            class = classPrev;
            stop = true;
        end
        centroidPrev = centroid;
        medoidPrev = medoid;
        classPrev = class;
        totalDistPrev = totalDist;
    end

end
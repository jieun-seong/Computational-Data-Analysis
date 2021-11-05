function [ class ] = mycluster( bow, K )
%
% Your goal of this assignment is implementing your own text clustering algo.
%
% Input:
%     bow: data set. Bag of words representation of text document as
%     described in the assignment.
%
%     K: the number of desired topics/clusters. 
%
% Output:
%     class: the assignment of each topic. The
%     assignment should be 1, 2, 3, etc. 
%
% For submission, you need to code your own implementation without using
% any existing libraries

% YOUR IMPLEMENTATION SHOULD START HERE!

    % Initialization

    ndocs = size(bow,1);
    nwords = size(bow,2);
    
    pi = rand(1,K);
    pi = pi./sum(pi);
    mu = rand(nwords,K);
    mu = mu./sum(mu);
    
    %Expectation

    gamma = zeros(ndocs,K);
    cluster = zeros(ndocs,1);
    clusterprev = ones(ndocs,1);

    while clusterprev ~= cluster

        clusterprev = cluster;
        p = ones(ndocs,K);
        p2 = zeros(ndocs,1);

        for k = 1:K
            for i = 1:ndocs
                for j = 1:nwords
                    p(i,k) = p(i,k)*(mu(j,k)^bow(i,j));
                end
            end
        end
        
        for i = 1:ndocs
            for k = 1:K
                p2(i,1) = sum(p(i,:).*pi(1,:));
            end
        end
    
        for k = 1:K
            for i = 1:ndocs
                gamma(i,k) = pi(1,k)*p(i,k)/p2(i,1);
            end
        end
    
        % Maximization

        for k = 1:K
            pi(1,k) = sum(gamma(:,k))/ndocs;
        end
    
        s = zeros(ndocs,K);
        for i = 1:ndocs
            for k = 1:K
                s(i,k) = sum(gamma(i,k).*bow(i,:));
            end
        end
    
        for k = 1:K
            for j = 1:nwords
                mu(j,k) = sum(gamma(:,k).*bow(:,j))/sum(s(:,k));
            end
        end
    
        % Assignment
    
        for i = 1:ndocs
            [~,cluster(i,1)] = max(gamma(i,:));
        end
    end

    class = cluster;

end



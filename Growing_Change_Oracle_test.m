%In this code we simulate the growing moving change problem for a sensor network of
%L nodes when the anomaly cannot grow more than a size of 3
clear all
clc
%network size
L=5;
error_count=0;
repetitions =1; %Number of monte carlo simulations
delay(1:repetitions) = 0;
pre_change_mean = 0;
post_change_mean = 1;
sigma = 1;
threshold =100;
horizon = 120000;
changepoint_1 = 1;
changepoint_2 = 10;
changepoint_3 = 20;
%changepoint_4 = 4000;
%changepoint_5 = 50000;
%changepoint_1 = horizon;
%changepoint_2 = horizon;
%changepoint_3 = horizon;
% changepoint_4 = horizon;
% changepoint_5 = horizon;
for q=1:1:repetitions
    Cusum_statistic(1:horizon)=0;
    for i = 1:1:horizon
        %if i >= changepoint_5
         %   Observations = normrnd(pre_change_mean,sigma,[L,1]);
          %  Observations(1:5) = normrnd(post_change_mean,sigma,[5,1]);
        %elseif i >= changepoint_4
         %   Observations = normrnd(pre_change_mean,sigma,[L,1]);
          %  Observations(1:4) = normrnd(post_change_mean,sigma,[4,1]);
          
          
        if i >= changepoint_3
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(1:3) = normrnd(post_change_mean,sigma,[3,1]);
        elseif i >= changepoint_2
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(1:2) = normrnd(post_change_mean,sigma,[2,1]);
        elseif i >= changepoint_1
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(1:1) = normrnd(post_change_mean,sigma);
        else %Pre-change observations generation
            ;
        end
        %PRE-CHANGE-MODE
        % JUST CHANGE THIS TO GO TO PRE-CHANGE
        %Observations = normrnd(pre_change_mean,sigma,[L,1]);
        
        %Oracle-CuSum statistic calculation- Dependeing on which point you
        %use bigger likelihood ratio
        
        
        if i >= changepoint_3
            LLR = log((normpdf(Observations(1),post_change_mean,sigma)*normpdf(Observations(2),post_change_mean,sigma)*normpdf(Observations(3),post_change_mean,sigma))/(normpdf(Observations(1),pre_change_mean,sigma)*normpdf(Observations(2),post_change_mean,sigma)*normpdf(Observations(3),post_change_mean,sigma))   );  
        elseif i >= changepoint_2
            LLR = log((normpdf(Observations(1),post_change_mean,sigma)*normpdf(Observations(2),post_change_mean,sigma))/(normpdf(Observations(1),pre_change_mean,sigma)*normpdf(Observations(2),post_change_mean,sigma))   );  
        elseif i >= changepoint_1
            LLR = log((normpdf(Observations(1),post_change_mean,sigma))/(normpdf(Observations(1),pre_change_mean,sigma))   );   
        else
            ;
        end
        
        if i==1
            Cusum_statistic(i) = max ( 0,  LLR  ) ;
        else
            Cusum_statistic(i) = max(   Cusum_statistic(i-1) + LLR  ,   0   );
        end
        
        
        if Cusum_statistic(i)>threshold
            delay(q) = i-changepoint_1+1; %DELAY
            %delay(q) = i; %FA %NNNNNNOTTTTTTTTT NEEEDEEED HERE
            break
        end
    end
        Cusum_statistic(i+1:horizon)=[];
        if mod(q,100)==0
             q
        end
        if i==horizon
              disp('error')
              error_count = error_count+1;
              delay(q)=-333;
        end 
end
delay( delay == -333)=[];
error_count
plot(Cusum_statistic)
average_delay = mean(delay) 
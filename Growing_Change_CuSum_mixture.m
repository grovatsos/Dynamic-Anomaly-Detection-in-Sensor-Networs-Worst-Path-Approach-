%In this code we simulate the growing moving change problem for a sensor network of
%L nodes when the anomaly cannot grow more than a size of 3
clear all
clc
%network size
L=10;
error_count=0;
repetitions =5000; %Number of monte carlo simulations
delay(1:repetitions) = 0;
pre_change_mean = 0;
post_change_mean = 1;
sigma = 1;
threshold =8;
rho_1=(1 / threshold); %Suggested in shaofeng's paper
rho_2=(1 / threshold); 
rho_3=0; %BY SHAOFENGS PAPER THE RHO FOR THE LAST PHASE MUST BE ZERO
horizon = 2000000;
%changepoint_1 = 1;
%changepoint_2 = 10;
%changepoint_3 = 20;
%changepoint_4 = 4000;
%changepoint_5 = 50000;
 changepoint_1 = horizon;
 changepoint_2 = horizon;
 changepoint_3 = horizon;
% changepoint_4 = horizon;
% changepoint_5 = horizon;
%Calculate all the sets of combinatios up to a size of 5 (maximum anomaly
%size)
Set_of_combs_of_size_2 = combntns([1:L],2);
Set_of_combs_of_size_3 = combntns([1:L],3);
%Set_of_combs_of_size_4 = combntns([1:L],4);
%Set_of_combs_of_size_5 = combntns([1:L],5);


for q=1:1:repetitions
    Cusum_statistic(1:horizon)=0;
    Omega_1(1:horizon)=0;
    Omega_2(1:horizon)=0;
    Omega_3(1:horizon)=0;
    %Omega_4(1:horizon)=0;
    %Omega_5(1:horizon)=0;
    
    for i = 1:1:horizon
        %GENERATE THE OBSERVATIONS ACCORDING TO EACH PHASE
        %From the symmetry of the test the faulty sensors don't need to
        %move
        %We will get the same results even if they dont move
        
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
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
        end

        %WD CUSUM STATISTIC CALCULATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        logs_to_add_1(1:L)=0;
        for j = 1:1:L
            logs_to_add_1(j) = (1/L)*( (normpdf(Observations(j),post_change_mean,sigma))/ (normpdf(Observations(j),pre_change_mean,sigma)) );
        end
        Z_1 = log(sum(logs_to_add_1));
        %%%
        logs_to_add_2(1:( nchoosek(L,2)) )=0;
        for j = 1:1:nchoosek(L,2)
                j_1 = Set_of_combs_of_size_2(j,1);
                j_2 = Set_of_combs_of_size_2(j,2);
                logs_to_add_2(j) = (1/(nchoosek(L,2)))*( (normpdf(Observations(j_1),post_change_mean,sigma)*normpdf(Observations(j_2),post_change_mean,sigma))/ (normpdf(Observations(j_1),pre_change_mean,sigma)*normpdf(Observations(j_2),pre_change_mean,sigma)) );               
        end
        Z_2 = log(sum(logs_to_add_2));
        %%%
        logs_to_add_3(1:( nchoosek(L,3)) )=0;
        for j = 1:1:nchoosek(L,3)
                j_1 = Set_of_combs_of_size_3(j,1);
                j_2 = Set_of_combs_of_size_3(j,2);
                j_3 = Set_of_combs_of_size_3(j,3);
                logs_to_add_3(j) = (1/(nchoosek(L,3)))*( (normpdf(Observations(j_1),post_change_mean,sigma)*normpdf(Observations(j_2),post_change_mean,sigma)*normpdf(Observations(j_3),post_change_mean,sigma))/ (normpdf(Observations(j_1),pre_change_mean,sigma)*normpdf(Observations(j_2),pre_change_mean,sigma)*normpdf(Observations(j_3),pre_change_mean,sigma)) );               
        end
        Z_3 = log(sum(logs_to_add_3));
        %%%
        %logs_to_add_4(1:( nchoosek(L,4)) )=0;
        %for j = 1:1:nchoosek(L,4)
         %       j_1 = Set_of_combs_of_size_4(j,1);
          %      j_2 = Set_of_combs_of_size_4(j,2);
           %     j_3 = Set_of_combs_of_size_4(j,3);
            %    j_4 = Set_of_combs_of_size_4(j,4);
             %   logs_to_add_4(j) = (1/(nchoosek(L,4)))*( (normpdf(Observations(j_1),post_change_mean,sigma)*normpdf(Observations(j_2),post_change_mean,sigma)*normpdf(Observations(j_3),post_change_mean,sigma)*normpdf(Observations(j_4),post_change_mean,sigma))/ (normpdf(Observations(j_1),pre_change_mean,sigma)*normpdf(Observations(j_2),pre_change_mean,sigma)*normpdf(Observations(j_3),pre_change_mean,sigma)*normpdf(Observations(j_4),pre_change_mean,sigma)) );               
        %end
        %%Z_4 = log(sum(logs_to_add_4));
        %%%
       % logs_to_add_5(1:( nchoosek(L,5)) )=0;
        %for j = 1:1:nchoosek(L,5)
         %       j_1 = Set_of_combs_of_size_5(j,1);
          %      j_2 = Set_of_combs_of_size_5(j,2);
           %     j_3 = Set_of_combs_of_size_5(j,3);
            %    j_4 = Set_of_combs_of_size_5(j,4);
             %   j_5 = Set_of_combs_of_size_5(j,5);
              %  logs_to_add_5(j) = (1/(nchoosek(L,5)))*( (normpdf(Observations(j_1),post_change_mean,sigma)*normpdf(Observations(j_2),post_change_mean,sigma)*normpdf(Observations(j_3),post_change_mean,sigma)*normpdf(Observations(j_4),post_change_mean,sigma)*normpdf(Observations(j_5),post_change_mean,sigma))/ (normpdf(Observations(j_1),pre_change_mean,sigma)*normpdf(Observations(j_2),pre_change_mean,sigma)*normpdf(Observations(j_3),pre_change_mean,sigma)*normpdf(Observations(j_4),pre_change_mean,sigma)*normpdf(Observations(j_5),pre_change_mean,sigma)) );               
     %   end
      %  Z_5 = log(sum(logs_to_add_5));
        %%%
        
        if i==1
            Omega_1(i) = Z_1 + log(1-rho_1);
            Omega_2(i) = max( [ log(rho_1)  ,  0]  )  +Z_2 +log(1-rho_2);
            Omega_3(i) = max([log(rho_1) +log(rho_2), log(rho_2) ,0  ] )+ Z_3 +log(1-rho_3);
          %  Omega_4(i) =  max([log(rho_1) +log(rho_2)  +log(rho_3) , log(rho_2) + log(rho_3) , log(rho_3),0 ]) +Z_4 + log(1-rho_4);
           % Omega_5(i) = max([log(rho_1) +log(rho_2)  +log(rho_3)+log(rho_4) , log(rho_2)  +log(rho_3)+log(rho_4), log(rho_3)+log(rho_4) , log(rho_4),0 ]) + Z_5 + log(1-rho_5);
        else
            Omega_1(i) = max([Omega_1(i-1) , 0 ]) + Z_1 + log(1-rho_1);
            Omega_2(i) = max([ log(rho_1),Omega_1(i-1) +log(rho_1) , Omega_2(i-1)   ]) +Z_2 +log(1-rho_2);
            Omega_3(i) = max([log(rho_1)+log(rho_2) , Omega_1(i-1)+log(rho_1)+log(rho_2) , Omega_2(i-1) +log(rho_2) , Omega_3(i-1)]) +Z_3 +log(1-rho_3);
          %  Omega_4(i) = max([ log(rho_1) +log(rho_2)  +log(rho_3) , Omega_1(i-1) + log(rho_1) +log(rho_2)  +log(rho_3) , Omega_2(i-1) +log(rho_2)  +log(rho_3) , Omega_3(i-1) + log(rho_3) , Omega_4(i-1)     ]) + Z_4 +log(1-rho_4);
           % Omega_5(i) = max([log(rho_1) +log(rho_2)  +log(rho_3)+log(rho_4) , Omega_1(i-1) + log(rho_1) +log(rho_2)  +log(rho_3)+log(rho_4) , Omega_2(i-1) +log(rho_2)  +log(rho_3)+log(rho_4) , Omega_3(i-1)   +log(rho_3)+log(rho_4) , Omega_4(i-1) +log(rho_4), Omega_5(i-1) ])   + Z_5 + log(1-rho_5);
        end
        Cusum_statistic(i) = max([ Omega_1(i), Omega_2(i), Omega_3(i),0  ] );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if Cusum_statistic(i)>threshold
            %delay(q) = i-changepoint_1+1; %DELAY
            delay(q) = i; %FA
            break
        end
    end
    Omega_1(i+1:horizon)=[];
    Omega_2(i+1:horizon)=[];
    Omega_3(i+1:horizon)=[];
   % Omega_4(i+1:horizon)=[];
    %Omega_5(i+1:horizon)=[];
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
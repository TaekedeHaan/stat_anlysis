clear all
close all
clc

%% Init 
sheet = 2; % which experiment do you want to load
label = {'Original', 'Replication'}; % label of the two experiments

% layout for plotting
fontSize = 15;
varNames = {'1', '2', '3', '4', '5', '6'};
dim = [200, 200, 500, 600];

% cohens d equation
cohens_s = @(x1mean, x2mean, x1std, x2std, n1, n2)  (x1mean - x2mean)./sqrt( ((n1 - 1)* x1std.^2 + (n2 - 1)* x2std.^2)./(n1 + n2 - 2));

%% Load and prepare data
% read excel file
[num,txt,raw] = xlsread(['Data', filesep 'Data-Both-Experiments-Morality-and-cleanliness.xlsx'],sheet);

% Determine study type
SBH(ismember(txt, label(1))) = true;
SBH(ismember(txt, label(2))) = false;
SBH = SBH(2:end)';

% split into result, note that the condition columns of both experiments
% have a different defintion.
if sheet == 1
    clean = num(:,1);
elseif sheet == 2
    clean(:,1) = (num(:,1) == 1);
    clean(:,1) = ~(num(:,1) == 2);
end
result = num(:,2:end);

%% SBH
% Cleanliness
nCleanSBH = sum(SBH & clean); % amount of samples
meanCleanSBH = mean(result((SBH & clean), :),1);
sdCleanSBH = std(result((SBH & clean), :),1);

% Neutral
nNeutOr = sum(SBH & ~clean); % amount of samples
meanNeutOr = mean(result((SBH & ~clean), :),1);
sdNeutOr = std(result((SBH & ~clean), :),1);

% Cohen's d
dOr = cohens_s(meanCleanSBH, meanNeutOr, sdCleanSBH, sdNeutOr, nCleanOr, nNeutOr);

% one way anova
[pOr, tblOr] = anova1(result(SBH, 7)', clean(SBH)');
NOr = sum(SBH);

%% Rep
% cleanliness
nCleanRep = sum(~SBH & clean);
meanCleanRep = mean(result((~SBH & clean), :),1);
sdCleanRep = std(result((~SBH & clean), :),1);

% Neutral
nNeutRep = sum(~SBH & ~clean);
meanNeutRep = mean(result((~SBH & ~clean), :),1);
sdNeutRep = std(result((~SBH & ~clean), :),1);

% Cohen's d
dRep = cohens_s(meanCleanRep, meanNeutRep, sdCleanRep, sdNeutRep, nCleanRep, nNeutRep);

% one way anova
[pRep, tblRep] = anova1(result(~SBH, 7)', clean(~SBH));
NRep = sum(~SBH);

%% Visualize data
% SBH
figure('Position', dim)
subplot(2,1,1)
boxplot(result(SBH & clean,1:6))
grid minor
ylim([0,7])
title('Original Study Score Cleanliness')
xlabel('Moral dilemma')
ylabel('Score')
set(gca,'Fontsize',fontSize)

subplot(2,1,2)
boxplot(result(SBH & ~clean,1:6))
grid minor
ylim([0,7])
title('Original Study Score Neutral')
xlabel('Moral dilemma')
ylabel('Score')
set(gca,'Fontsize',fontSize)

saveas(gca, 'fig/score_sbh', 'jpg')
saveas(gca, ['fig/score_sbh.eps'], 'epsc')

% Rep
figure('Position', dim)
subplot(2,1,1)
boxplot(result(~SBH & clean,1:6))
grid minor
ylim([0,7])
title('Replicate Study Score Cleanliness')
xlabel('Moral dilemma')
ylabel('Score')
set(gca,'Fontsize',fontSize)

subplot(2,1,2)
boxplot(result(~SBH & ~clean,1:6))
grid minor
ylim([0,7])
title('Replicate Study Score Neutral')
xlabel('Moral dilemma')
ylabel('Score')
set(gca,'Fontsize',fontSize)

saveas(gca, 'fig/score_rep', 'jpg')
saveas(gca, ['fig/score_rep.eps'], 'epsc')

%% Disp results
disp('========MEAN and SD========')
disp('Original cleanliness mean');
disp(meanCleanSBH);
disp('Original cleanliness std');
disp(sdCleanSBH);

disp('Original neutral mean');
disp(meanNeutOr);
disp('Original neutral std');
disp(sdNeutOr);

disp('Replicate cleanliness mean');
disp(meanCleanRep);
disp('Replicate cleanliness std');
disp(sdCleanRep);

disp('Replicate neutral mean');
disp(meanNeutRep);
disp('Replicate neutral std');
disp(sdNeutRep);

disp('========Correlation========')
if showPlot   
    % original
    [corrNeutOr, pCorrNeutOr] = corrplot(result((SBH & ~clean), 1:6), 'type','pearson','Varnames', varNames);
    saveas(gca, 'fig/SBH_Neutral', 'jpg')
    saveas(gca, 'fig/SBH_Neutral.eps', 'epsc')
    
    [corrCleanOr, pCorrCleanOr] =  corrplot(result((SBH & clean), 1:6),'type','pearson','Varnames', varNames);
    saveas(gca, 'fig/SBH_Cleanliness', 'jpg');
    saveas(gca, 'fig/SBH_Cleanliness.eps', 'epsc');
    
    % Replicate
    [corrNeutRep, pCorrNeutRep] = corrplot(result((~SBH & ~clean), 1:6),'type','pearson','Varnames', varNames);
    saveas(gca, 'fig/Rep_Neutral', 'jpg');
    saveas(gca, ['fig/Rep_Neutral.eps'], 'epsc');
    
    [corrCleanRep, pCorrCleanRep] = corrplot(result((~SBH & clean), 1:6),'type','pearson','Varnames', varNames);
    saveas(gca, 'fig/Rep_Cleanliness', 'jpg')
    saveas(gca, ['fig/Rep_Cleanliness.eps'], 'epsc')
end

disp('========Cohen d=========')
disp('Original Cohens d')
disp(dOr)

disp('Replicate Cohens d')
disp(dRep)

disp('========ANOVA========')
disp('N original')
disp(NOr)

disp('p original')
disp(pOr)

disp('F original')
disp(tblOr{2,5})

disp('N Replicate')
disp(NRep)

disp('p Replicate')
disp(pRep)

disp('F Replicate')
disp(tblRep{2,5})

%% Print latex table (THIS REQUIRES ADDITIONAL FUNCTIONS!)
% the function disp_latex_table.m and matrix2latex.m should be added to 
% your path.
disp('========LATEX TABLE========')
% cleanliness
disp_latex_table(meanCleanSBH, meanCleanRep)
disp_latex_table(sdCleanSBH, sdCleanRep)

% neutral
disp_latex_table(meanNeutOr, meanNeutRep)
disp_latex_table(sdNeutOr, sdNeutRep)

% d
disp_latex_table(dOr, dRep)

% correlation matrices
matrix2latex(corrCleanOr, 'tab/corrCleanOr.tex', 'format', '%10.2f','rowLabels',varNames, 'columnLabels', varNames);
matrix2latex(corrNeutOr, 'tab/corrNeutOr.tex', 'format', '%10.2f','rowLabels',varNames, 'columnLabels', varNames);

matrix2latex(corrCleanRep, 'tab/corrCleanRep.tex', 'format', '%10.2f','rowLabels',varNames, 'columnLabels', varNames);
matrix2latex(corrNeutRep, 'tab/corrNeutRep.tex', 'format', '%10.2f','rowLabels',varNames, 'columnLabels', varNames);
% corrCleanOr(6,1)
% pCorrCleanOr(6,1)
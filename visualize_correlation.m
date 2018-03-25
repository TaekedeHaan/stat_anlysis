clear all
close all
clc

% parameters
fontSize = 15;
mu = 0;
sigma = 0.5;
xCorr = -2:0.01:2;

% gen dat
M = mu + sigma*randn(1000,2);
R = [1 0.64; 0.64 1];
L = chol(R);
M = M*L;

% split data
x = M(:,1);
y = M(:,2);

% plot data
figure('Position', [200, 200, 500, 400])
plot(x,y,'o')
hold on
plot(xCorr, xCorr* R(1,2),'--', 'linewidth', 2)
xlabel('x')
ylabel('y')
grid minor
title(['Data with a correlation of ' num2str(R(1,2))])
set(gca,'Fontsize',fontSize)
axis([-2, 2, -2, 2])
saveas(gca, 'fig/corr', 'jpg')
saveas(gca, ['fig/corr.eps'], 'epsc')

corr(x,y)
%% FROC 
% data of ensemble classifier
% % y_ensem=[0.05,0.15,0.25,0.4,0.45,0.5,0.65,0.65,0.65,0.65];
% % x_ensem=[1.58,2,5.42,7.8,8.68,10,14.7,14.76,15.94,16.54];
% % plot(x_ensem,y_ensem);
% yensem=[0.1,0.15,0.2,0.35,0.5,0.6,0.65,0.65,0.65,0.65];
% xensem=[0,0.88,2.24,6.88,9.26,13.1,14.68,14.74,14.9,15.5];
% plot(xensem,yensem);
%% ensemble
clc;clear all
yensem=[0.1,0.25,0.4,0.5,0.55,0.6,0.65,0.65,0.65,0.65];
% xensem=[0,2.38,7.02,10.86,11.74,13.1,14.48,14.74,14.9,15.5];
xensem=[0,11.9,35.1,54.3,58.7,65.5,74.3,73.7,74.5,77.5];
% semilogx(xensem,yensem)
plot(xensem,yensem,'-r','LineWidth',1);
set(gca,'YTick',0:0.1:0.7)  
% axis([xmin xmax ymin ymax])
axis([10^(-1) 90 0 0.7])
xlabel('Average number of FPs per image');  
ylabel('sensitivity');  
hold on
%% semilogx(x,y)
ynb=[0.1,0.3,0.4,0.45,0.5,0.55,0.6,0.6,0.6,0.6];
xnb=[0.1,11.2,28.8,41,44.8,51.8,59.8,59.2,59.5,62];
plot(xnb,ynb,'-b', 'LineWidth',1);
%%  lazar ensemble
Yen=[0,0.2,0.25,0.35,0.4,0.45,0.5,0.5,0.5,0.5];
Xen=[0.1,12.5,34,65.3,73.3,80,83.5,85,86,86];
plot(Xen,Yen,'--r','LineWidth',1);

%%  lazar nb
Ynb=[0.05,0.25,0.35,0.45,0.5,0.55,0.55,0.55,0.55,0.55];
Xnb=[0.1,10,30.5,57.9,65.7,71.6,71.7,71.9,73.1,76.7];
plot(Xnb,Ynb,'--b','LineWidth',1);

h=legend('Ens1','NB1','Ens','NB','Location','southeast');





% 
% %% 1NN
% ynn=[0.05,0.2,0.25,0.3,0.35,0.4,0.45,0.45,0.45,0.45];
% xnn=[0.3,11.5,29.9,45.6,49.1,55.5,64.8,65.1,65.4,67.9];
% plot(xnn,ynn,':b', 'LineWidth',1);
% 
% %% SRC
% ysrc=[0.1,0.25,0.3,0.35,0.4,0.45,0.5,0.5,0.5,0.5];
% xsrc=[0.1,10.2,21.4,28.2,32.0,39.5,47.8,480,483,511];
% plot(xsrc,ysrc,'-.m', 'LineWidth',1);
% 
% %% SVM
% ysvm=[0.1,0.3,0.35,0.45,0.5,0.55,0.6,0.6,0.6,0.6];
% xsvm=[0.1,12.2,32.7,50.5,54.4,62.5,69.7,69.9,70.1,71.6];
% plot(xsvm,ysvm,'--g', 'LineWidth',1);

% 
% h=legend('esemble','nb','knn','src','svm','Location','southeast');




%% FROC 
% data of ensemble classifier
% % y_ensem=[0.05,0.15,0.25,0.4,0.45,0.5,0.65,0.65,0.65,0.65];
% % x_ensem=[1.58,2,5.42,7.8,8.68,10,14.7,14.76,15.94,16.54];
% % plot(x_ensem,y_ensem);
% yensem=[0.1,0.15,0.2,0.35,0.5,0.6,0.65,0.65,0.65,0.65];
% xensem=[0,0.88,2.24,6.88,9.26,13.1,14.68,14.74,14.9,15.5];
% plot(xensem,yensem);
%% ensemble
clc;clear all
yensem=[0.1,0.25,0.4,0.5,0.55,0.6,0.65,0.65,0.65,0.65];
% xensem=[0,2.38,7.02,10.86,11.74,13.1,14.48,14.74,14.9,15.5];
xensem=[0,11.9,35.1,54.3,58.7,65.5,74.3,73.7,74.5,77.5];
% semilogx(xensem,yensem)
plot(xensem,yensem,'-r','LineWidth',1);
set(gca,'YTick',0:0.1:0.7)  
% axis([xmin xmax ymin ymax])
axis([10^(-1) 80 0 0.7])
xlabel('Average number of FPs per image');  
ylabel('sensitivity');  
hold on
%% semilogx(x,y)
ynb=[0.1,0.3,0.4,0.45,0.5,0.55,0.6,0.6,0.6,0.6];
xnb=[0.1,11.2,28.8,41,44.8,51.8,59.8,59.2,59.5,62];
plot(xnb,ynb,'-b', 'LineWidth',1);

%% 1NN
ynn=[0.05,0.2,0.25,0.3,0.35,0.4,0.45,0.45,0.45,0.45];
xnn=[0.3,11.5,29.9,45.6,49.1,55.5,64.8,65.1,65.4,67.9];
plot(xnn,ynn,':b', 'LineWidth',1);

%% SRC
ysrc=[0.1,0.25,0.3,0.35,0.4,0.45,0.5,0.5,0.5,0.5];
xsrc=[0.1,10.2,21.4,28.2,32.0,39.5,47.8,480,483,511];
plot(xsrc,ysrc,'-.m', 'LineWidth',1);

%% SVM
ysvm=[0.1,0.3,0.35,0.45,0.5,0.55,0.6,0.6,0.6,0.6];
xsvm=[0.1,12.2,32.7,50.5,54.4,62.5,69.7,69.9,70.1,71.6];
plot(xsvm,ysvm,'--g', 'LineWidth',1);


h=legend('Ens','NB','KNN','SRC','SVM','Location','southeast');
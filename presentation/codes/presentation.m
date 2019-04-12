%% Bayesian Inference Animation
ex = 30;
%run baRegInf_I.m

load baRegInf_I.mat
fig = figure;
movie(fig,mov,ex)
%%
load baRegInf_II.mat
fig = figure;
movie(fig,mov,ex)

%% Example Plots

load baRegFunctionSpaceLinearprior.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceLinearpost.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpacePoly5prior.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpacePoly5post.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceAbsprior.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceAbspost.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceLegendreprior.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceLegendrepost.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceBellShapeprior.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceBellShapepost.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceBellShapeprior.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpaceBellShapepost.mat
fig = figure;
movie(fig,mov,ex)

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

load baRegFunctionSpaceLinear.mat
fig = figure;
movie(fig,mov,ex)

load baRegFunctionSpacePoly5post.mat
fig = figure;
movie(fig,mov,ex)


load baRegFunctionSpacePoly5prior.mat
fig = figure;
movie(fig,mov,ex)

run baRegFunctionSpace3.m
clc;
clear;
close all;

[X,Y,SNR] = build_feature_dataset(20000);

trained_model = train_amc_model(X,Y);

save trained_model.mat trained_model

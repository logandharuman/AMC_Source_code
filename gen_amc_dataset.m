function [x, label, fs, snr] = gen_amc_dataset()

classes = ["AM","DSBSC","FM","CARRIER","DIGITAL","NOISE"];
label = classes(randi(numel(classes)));

fs  = randi([20e3 100e3]);
N   = 4096;
t   = (0:N-1)/fs;
% snr = randsample([-2:15],1,true, ...
%      [0.15 0.15 0.15 0.12 0.10 0.08 0.07 0.06 0.05 0.04 0.02 0.01 0.005 0.003 0.002 0.001 0.001 0.001]);
snr = randsample(8:13, 1);

% snr = randi([-8:2]);
fc = 0.1*fs + 0.3*fs*rand;
fm = 100 + 3e3*rand;

switch label
    case "AM"
        m = cos(2*pi*fm*t);
        x = (1+0.7*m).*cos(2*pi*fc*t);

    case "DSBSC"
        m = cos(2*pi*fm*t);
        x = m .* cos(2*pi*fc*t);

    case "FM"
        m = cos(2*pi*fm*t);
        x = cos(2*pi*fc*t + 5*cumsum(m)/fs);

    case "CARRIER"
        x = cos(2*pi*fc*t);

    case "DIGITAL"
    M = 4;                           % QPSK-like behavior
    sps = randi([10 40]);            % random symbol rate
    Ns = ceil(N/sps);                % generate extra symbols

    bits = randi([0 M-1], 1, Ns);
    sym  = exp(1j*2*pi*bits/M);

    x_bb = repelem(sym, sps);        % baseband digital
    x_bb = x_bb(1:N);                % safe trim

    x = real(x_bb .* exp(1j*2*pi*fc*t));


    case "NOISE"
        x = randn(1,N);
end

% Add noise
x = awgn(x, snr, 'measured');
end

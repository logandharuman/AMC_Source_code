function feat = extract_features_iq_EW_full(x, fs)

x = x(:).';
x = x / (sqrt(mean(abs(x).^2)) + eps);

% ---- ANALYTIC SIGNAL ----
if isreal(x)
    x = hilbert(x);
end

env = abs(x);
phi = unwrap(angle(x));
dphi = diff(phi);

% ---- SPECTRAL FEATURES ----
N = length(x);
X = fftshift(abs(fft(x)));
X = X / max(X);

bw = obw(x, fs);                       % occupied bandwidth
spec_flat = geomean(X+eps)/mean(X+eps);
spec_kurt = kurtosis(X);

% ---- MODULATION FEATURES ----
env_var = var(env);                    % AM vs FM
phase_var = var(dphi);                 % FM vs others
zc_rate = sum(abs(diff(sign(real(x)))))/(2*N);

% ---- CYCLOSTATIONARY PROXY ----
R = abs(xcorr(real(x), 100, 'coeff'));
cyclo_peak = max(R(101+5:end));        % skip zero lag

% ---- NOISE DISCRIMINATOR ----
spec_entropy = -sum(X.*log(X+eps));

% ---- FEATURE VECTOR ----
feat = [ ...
    bw, ...
    spec_flat, ...
    spec_kurt, ...
    env_var, ...
    phase_var, ...
    zc_rate, ...
    cyclo_peak, ...
    spec_entropy ];

feat = feat(:).';
end

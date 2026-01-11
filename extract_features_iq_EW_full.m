function feat = extract_features_iq_EW_full(x, fs)

% ---- PREPROCESSING ----
x = x(:).';
x = x / (sqrt(mean(abs(x).^2)) + eps);

% ---- ANALYTIC SIGNAL ----
if isreal(x)
    x = hilbert(x);
end

env  = abs(x);
phi  = unwrap(angle(x));
dphi = diff(phi);

% ---- SPECTRAL FEATURES ----
N = length(x);
X = fftshift(abs(fft(x)));
X = X / max(X + eps);
P = X.^2;

inst_freq = diff(unwrap(angle(x)));
if_kurt = kurtosis(inst_freq);

IF = abs(fft(inst_freq));
IF = IF / max(IF + eps);

lf_ratio = sum(IF(2:5)) / sum(IF);

bw = obw(x, fs);                       
spec_flat = geomean(X + eps) / mean(X + eps);
spec_kurt = kurtosis(X);

% ---- MODULATION FEATURES ----
env_var   = var(env);                 
phase_var = var(dphi);                
zc_rate   = sum(abs(diff(sign(real(x)))))/(2*N);

% ---- CYCLOSTATIONARY PROXY ----
R = abs(xcorr(real(x), 100, 'coeff'));
cyclo_peak = max(R(101+5:end));

% ---- NOISE DISCRIMINATOR ----
spec_entropy = -sum(X .* log(X + eps));

% ==========================================================
%        🔥 ADDED CARRIER / AM-SPECIFIC FEATURES 🔥
% ==========================================================

% 1) Carrier Power Ratio (dominant spectral line)
carrier_ratio = max(P) / (sum(P) + eps);

% 2) Envelope DC Ratio (DSB-LC vs DSB-SC)
env_dc_ratio = mean(env) / (std(env) + eps);

% 3) Spectral Line Count (carrier vs modulated)
line_count = sum(P > 0.2 * max(P));

% 4) AM Modulation Index Estimate
m_est = (max(env) - min(env)) / (max(env) + eps);

% ---- FEATURE VECTOR ----
feat = [ ...
    bw, ...
    spec_flat, ...
    spec_kurt, ...
    env_var, ...
    phase_var, ...
    zc_rate, ...
    cyclo_peak, ...
    spec_entropy, ...
    carrier_ratio, ...
    env_dc_ratio, ...
    line_count, ...
    m_est, ...
    if_kurt, ...
    lf_ratio ];

feat = feat(:).';
end

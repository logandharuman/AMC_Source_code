function [final_class, confidence_pct] = confidence_gate( ...
    scores, conf_feat, snr_est, class_names)

% ================================
% 1. Normalize ECOC scores → probs
% ================================
scores = scores - max(scores);        % numerical stability
p = exp(scores);
p = p / sum(p);

[p_max, idx] = max(p);
p_sorted = sort(p,'descend');
margin = p_sorted(1) - p_sorted(2);

% ================================
% 2. Raw confidence (model trust)
% ================================
raw_conf = p_max * margin;   % ∈ [0, ~0.5]

% ================================
% 3. SNR-aware confidence scaling
% ================================
% Low SNR  → penalize confidence
% High SNR → allow confidence to rise
snr_gain = min(max((snr_est + 2)/12, 0.25), 1.0);

conf_snr = raw_conf * snr_gain;

% ================================
% 4. Convert to percentage
% ================================
confidence_pct = 100 * conf_snr;
confidence_pct = min(max(confidence_pct, 0), 100);

% ================================
% 5. Decision logic
% ================================
T_pct = 15;    % 15% minimum confidence (tuneable)

if confidence_pct < T_pct
    final_class = "UNKNOWN";
else
    final_class = string(class_names(idx));
end

end

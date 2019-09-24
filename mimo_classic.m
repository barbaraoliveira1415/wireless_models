%% Model for MIMO
% Md -- r receive antennas -> r received samples acress r receive antennas
% Ms -- t transmit antennas -> t symbols can be transmitted on t transmit antennas

% H channel matrix - Rayleigh flat-fading and quasi-static duri ng
% hij channel coeficient between ith receive e jth transmit
% H -> Md x Ms -> Ms da fonte, Mr do relay, Md do destino 



function [ratio,nmse] = mimo_classic(Ms,Md,mod_level,SNR)
%% Antennas specifications
%for interation = 1:10

%Md=8; % r received samples 
%Ms=4; % transm samples 
r=Md;
t=Ms;
n=100; %numbers of symbols transmit
%mod_level = 4; % Size of signal constellation / Modulation Order
k = log2(mod_level); % Number of bits per symbol
%SNR = 100;

nf = 2*(mod_level-1)/3; %Average signal energy per symbol
EsNo = 10.^(SNR/10); % Energy per symbol to noise power spectral density
sigma = sqrt(1/(2*EsNo));

%% Signal imput
%TX1= round(rand(1,100)); %-1+1i*(2*round(rand(1,100))-1);
%TX2= round(rand(1,100)); %-1+1i*(2*round(rand(1,100))-1);
%s= [TX1; TX2]; % matrix of symbols (2x100) transmitted on t antennas
s = round(rand(Ms,n)); % matrix of symbols (trans antenas, n symbols)
%s = randn(Ms,Md);
%% Signal modulation - QAM
s_transm = qammod (s,mod_level);    
s_transm = s_transm./(sqrt(nf));

%% Channel
H = (randn(Md,Ms)+1i*randn(Md,Ms))/sqrt(Ms*Md);
    %[0.8+0.27*1i 0.12+0.95*1i 0.6+0.15*1i; 
    %0.9+0.5*1i 0.91+0.96*1i 0.09+0.97*1i]; % channel matrix t = 2, r=2 : 2x2 MdxMs

%% MIMO system
Y = H*s_transm ; % 
%Y_noise = awgn(Y,SNR,'measured'); % Output of the system
Y_noise = Y +sigma*(randn(Md,n)+1i*randn(Md,n));
%% MIMO receivers

% When the number of transmit antennas is equal with the number of
% receive antennas, r = t
s_rec = round(rand(Md,n));
if r==t
   s_rec = inv(H)*Y_noise;
end

% When the number of receive antenas is greater than the number of transmit
% antennas - invertível : least square solution

if r>t 
    for i = 1:100
        s_rec = pinv(H)*Y_noise; 
        e = norm(s_rec - s_transm,'fro')^2;
        if e <= 10^-6
            break
        end
    end
end

%% Signal demodulation
s_demol = qamdemod(s_rec(1:end,:),mod_level);

%% Error count
[number,ratio] = symerr(s,s_demol);
nmse = norm(s_rec - s_transm,'fro')^2/(norm(s_transm,'fro')^2);

%end
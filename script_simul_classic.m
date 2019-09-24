%% Script para simulação do sistema MIMO


% pre-simulation commands
clear all;
clc;
%close all;
warning off

% profile on
% General simulation parameters
mod_lev = 4;    % modulation qam order
SNR = [0:3:15]*1; % snr of the first hop% 0:5:25
rep = [200000 400000 600000 800000 900000 1000000]*0.001; % monte carlo repetititions
M = 4;

Ms=4; Md=2*Ms; 

% output variables KR-STFC
BER1=zeros(length(rep),1);


for k=1:length(SNR)
    
    disp(['SNR: ',num2str(SNR(k))]);
    
    ber1 = 0; nmse1=0; 
    for n=1:rep(k)
        
        
        % MIMO Classic KR-STC: mimo_krstc(N,P,Ms,Md,SNR);
        [temp1,temp2] = mimo_classic(Ms,Md,mod_lev,SNR(k));
        ber1 = ber1+temp1;
        nmse1 = nmse1+temp2;

        
               
        
    end
    
    
    % BER
        BER1(k,:)= ber1/rep(k);
    disp(['BER MIMO: ',num2str(BER1(k,:))]);
    
    
    % NMSE
    NMSE1(k,:)= nmse1/rep(k);
    disp(['NMSE MIMO: ',num2str(NMSE1(k,:))]);

    
    
    
end

figure();
axes('fontsize',08);
semilogy(SNR,BER1);hold on;
xlabel('E_s/N_0 [dB]','Interpreter', 'Latex');
ylabel ('SER');
grid on
legend('Receptoras Md = 8, Transmissoras Ms = 4');

%,'-b*','linewidth'


figure();
axes('fontsize',08);
semilogy(SNR,NMSE1);grid on; hold on;
xlabel('SNR [dB]');
ylabel ('Channel NMSE');
legend('Receptoras Md = 8, Transmissoras Ms = 4')

%,'-bo','linewidth',1.5
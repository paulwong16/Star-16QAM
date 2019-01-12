EbN0_dB = 0:0.1:15;
EbN0 = 10.^(EbN0_dB/10);
BER1 = erfc(sqrt(EbN0*sin(pi/8)*sin(pi/8)));
BER2 = 0.5*erfc(sqrt((2*0.64/4.24)/2*EbN0));
BER = BER1.*BER2;
SER = BER1.*BER2./4;
BERx = 1.5*erfc(sqrt((6/15)*EbN0));
SERx = BERx./4;
figure('Name','Bit Error Rate');
semilogy(EbN0_dB,BER,'-b',EbN0_dB,BERx,'-r')
grid on
legend('Star-16QAM','Square-16QAM')
ylabel('BER')
xlabel('E_b/N_0 (dB)')
title('Bit Error Rate')
hold on
figure('Name','Symbol Error Rate');
semilogy(EbN0_dB,SER,'-b',EbN0_dB,SERx,'-r')
grid on
legend('Star-16QAM','Square-16QAM')
ylabel('SER')
xlabel('E_s/N_0 (dB)')
title('Symbol Error Rate')
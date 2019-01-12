clc
snr=0:0.1:20;% define the range

% ber_qamm=qamm_func(snr);
ber_qamsquare=zeros(size(snr));
ber_qamm=zeros(size(snr));
ber_qamsquareg=zeros(size(snr));

for i=1:length(snr)
ber_qamsquare(i)=qamsquare_func(snr(i));
ber_qamm(i)=qamm_func(snr(i));
ber_qamsquareg(i)=qamsquareG_func(snr(i));
end
figure
plot(snr,ber_qamm)
hold on
plot(snr,ber_qamsquare)
hold on
plot(snr,ber_qamsquareg)
hold off
xlabel('SNR(dB)')
ylabel('Bit Error Rate')
legend('Star-16QAM','Square-16QAM','Square-16QAM-Gray')
function ber = qamm_func( snr )
%Star-16QAM

% Random bit sequence
numberOfBits = 1e4;
x = rand(1, numberOfBits);
x( x < 0.5 ) = 0;
x( x >= 0.5 ) = 1;

% Radius of inner and outer circle
r1 = sqrt(4.88);
r2 = r1*1.76;

% Define mapping table applying Gray mapping
mappingTable(1) = r1 * exp(1i* 0);
mappingTable(2) = r1 * exp(1i* pi/4);
mappingTable(3) = r1 * exp(1i* 3*pi/4);
mappingTable(4) = r1 * exp(1i* pi/2);
mappingTable(5) = r1 * exp(1i* 7*pi/4);
mappingTable(6) = r1 * exp(1i* 3*pi/2);
mappingTable(7) = r1 * exp(1i* pi);
mappingTable(8) = r1 * exp(1i* 5*pi/4);
mappingTable(9:16) = mappingTable(1:8) ./ r1 .* r2;

if mod(numberOfBits, 4) ~= 0
    error('numberOfBits must be a multiple of 4.');
end
mappedSymbols = zeros(1, numberOfBits / 4);

% Map bits to symbols
for i = 1:4:length(x)
    
    symbolBits = x(i:i+3);
        
    symbolIndex = 2^3 * symbolBits(1) + 2^2 * symbolBits(2) + 2^1 * symbolBits(3) + 2^0 * symbolBits(4);
    
    % Mapping
    mappedSymbols((i - 1)/4 + 1) = mappingTable( symbolIndex + 1);
end

% Add white Gaussian noise
meanSignalPower = (r1^2 + r2^2)/2;
snr_lin = 10^(snr/10); % linear scale
meanNoisePower = meanSignalPower ./ snr_lin;
receivedSignal = mappedSymbols + randn(1, length(mappedSymbols)) * sqrt(meanNoisePower/2) +...
    1i * randn(1, length(mappedSymbols)) * sqrt(meanNoisePower/2);

% Decision and demapping
receivedBits = zeros(1, numberOfBits / 4);
for i = 1:length(receivedSignal)
  [mindiff minIndex] = min(receivedSignal(i) - mappingTable);
  symbolIndex = minIndex - 1;
  bitString = dec2bin(symbolIndex, 4);
  receivedBits((i-1)*4 + 1) = str2double(bitString(1));
  receivedBits((i-1)*4 + 2) = str2double(bitString(2));
  receivedBits((i-1)*4 + 3) = str2double(bitString(3));
  receivedBits((i-1)*4 + 4) = str2double(bitString(4));
end

numberOfBitErrors = nnz( x - receivedBits );
ber = numberOfBitErrors / numberOfBits; % bit error rate
disp(['SNR: ' num2str(snr) ' dB']);
disp(['Bit error rate (BER): ' num2str(ber)]);

% figure;
% plot( real(receivedSignal), imag(receivedSignal), '.'); hold on;
% absLim = max( max(real(receivedSignal)), max(imag(receivedSignal)));
% xyLimits = [-absLim*1.1 absLim*1.1];
% xlim( xyLimits );
% ylim( xyLimits );
% plot( real(mappedSymbols), imag(mappedSymbols), '.r'); hold off;
% xlim( xyLimits );
% ylim( xyLimits );
% xlabel('In-Phase');
% ylabel('Quadrature');
% legend('received', 'transmitted');
end


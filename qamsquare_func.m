function ber=qamsquare_func(snr)
M = 16;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
n = 1e4;                    % Number of bits to process
numSamplesPerSymbol = 1;    % Oversampling factor


rng default                 % Use default random number generator
dataIn = randi([0 1],n,1);  % Generate vector of binary data

dataInMatrix = reshape(dataIn,length(dataIn)/k,k);   % Reshape data into binary k-tuples, k = log2(M)
dataSymbolsIn = bi2de(dataInMatrix);                 % Convert to integers

dataMod = qammod(dataSymbolsIn,M,'bin');         % Binary coding, phase offset = 0
dataModG = qammod(dataSymbolsIn,M); % Gray coding, phase offset = 0

receivedSignal = awgn(dataMod,snr,'measured');
receivedSignalG = awgn(dataModG,snr,'measured');

% sPlotFig = scatterplot(receivedSignal,1,0,'.');
% hold on
% scatterplot(dataMod,1,0,'.r',sPlotFig)

dataSymbolsOut = qamdemod(receivedSignal,M,'bin');
dataSymbolsOutG = qamdemod(receivedSignalG,M);

dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:);                   % Return data in column vector
dataOutMatrixG = de2bi(dataSymbolsOutG,k);
dataOutG = dataOutMatrixG(:);                 % Return data in column vector

[numErrors,ber] = biterr(dataIn,dataOut);
fprintf('\nThe binary coding bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors)
end
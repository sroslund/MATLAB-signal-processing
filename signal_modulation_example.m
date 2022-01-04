close all;
clear all;
clc;  

carrier = 500e3;                             % carrier signal's frequency
sampling = carrier*10;                       % sampling rate
dt = 1/sampling;

message = [6 0 4 -6 2];                      % the message to transmit
message_freq = carrier/10;                   % The message's frequency                 

t=0:dt:length(message)/message_freq - dt;    % our time vector for transmitting the message

carrier_signal = cos(2*pi*carrier*t);        % carrier signal used in modulation

encoded=[];  % message signal
for ii=1:length(message)
    encoded=[encoded message(ii)*ones(1,length(t)/length(message))]; % The signal we want to transmit
end

modulated_message = encoded .*carrier_signal;     % the modulated signal - the encoding signal multiplied by the carrier

freq_domain_message = fftshift(fft(modulated_message,length(modulated_message))*dt); % frequency domain signals
f = linspace(-pi,pi,length(modulated_message))/dt/2/pi;      % creating the frequency vector for plotting the result

filter = @(f) 2*(abs(f)<500e3);                   % we use an idealized filtering transfer function
local_oscillator = cos(2*pi*carrier*t);           % definition for the local oscillator

recieved_mess = modulated_message .* local_oscillator; % getting recieved message by multiplying local oscillator and message
freq_recieved = fftshift(fft(recieved_mess,length(recieved_mess)))*dt; % finding frequency domain recieved signal
filtered_message = freq_recieved .* filter(f);           % filtering the recieved message
received_message = ifft(ifftshift(filtered_message))/dt; % converting back to time domain

subplot(4,1,1);
plot(t,modulated_message);                   % plotting the modulated message in the time domain
title("modulated message in the time domain");
xlabel("time (s)");
ylabel("signal amplitude");
subplot(4,1,2);
plot(f,abs(freq_domain_message));            % plotting magnitude of message in frequency domain
title("modulated message in the frequency domain");
xlabel("freqency (HZ)");
ylabel("signal magnitude");
subplot(4,1,3);
plot(f,abs(filtered_message));               % plotting magnitude of filtered message in frequency domain
title("Filtered modulated message in the frequency domain");
xlabel("frequency (HZ)");
ylabel("signal magnitude");
subplot(4,1,4);
plot(t,received_message);                    % plotting recieved message in the time domain
title("Recieved message in time domain");
xlabel("time (s)");
ylabel("signal amplitude");
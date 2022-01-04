close all;
clear all;
clc;

r = 10000;                % setting the constant's values for a circuits transfer function         
c = 133*10^-9;
m = 0.9;

f = 0:.1:200;             % creating a frequency vector for plotting the transfer function
w = 2*pi*f;               % calculating angular frequency


H = @(w) ((1+m)*((2*j*w*r*c).^2+1))./((2*j*w*r*c).^2+4*(1-m)*j*w*r*c+1);  % defining a circuit's transfer function

subplot(2,1,1);
plot(f,abs(H(w)));                                  % plotting the magnitude of the transfer function 
hold on;
title('Transfer Function Magnitude');
xlabel("frequency (HZ)");
ylabel("magnitude");
subplot(2,1,2);
plot(f,angle(H(w))*180/pi);                         % plotting the phase of the transfer function
title('Transfer Function Phase');
xlabel("frequency (HZ)");
ylabel("phase (degrees)");

load ecg_signal.mat;                                 % loading an ecg signal

dT = t(2) - t(1);                                    % calculating signals time step dt

W=linspace(-pi,pi,length(ecg)); 
w=W/dT;                                              % creating angular frequency vector
f=w/2/pi;                                            % creating the frequency vector

x=ecg;
X = fftshift(fft(x))*dT;                             % finding frequency domain signal
Z = X .* H(w);                                       % finding frequency domain output
z = ifft(ifftshift(Z))/dT;                           % finding time domain output

figure();
subplot(4,1,1);
plot(t,x);                                           % plotting and labeling noisy signal
title("Noisy time domain signal x(t)");
xlabel("time(S)");
ylabel("signal amplitude");
subplot(4,1,2);
plot(f,abs(X));                                      % plotting and labeling noisy frequency domain signal
title("Noisy frequency domain signal X(f)");
xlabel("frequency (HZ)");
ylabel("magnitude");
subplot(4,1,3);
plot(f,abs(Z));                                      % plotting and labeling filtered frequency domain signal
title("Filtered frequency domain signal Z(f)");
xlabel("frequency (HZ)");
ylabel("magnitude");
subplot(4,1,4);
plot(t,z);                                           % plotting and labeling filtered time domain signal
title("Filtered time domain signal z(t)");
xlabel("time (S)");
ylabel("signal amplitude");

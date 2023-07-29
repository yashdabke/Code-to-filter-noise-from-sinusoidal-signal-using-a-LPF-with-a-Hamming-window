clc;
close all;
fp = 1000;
fst = 3000;
fs = 10000;

%converting to rad/sec

wp = 2*(fp/fs);
wst = 2*(fst/fs);

%generating a sinusoidal signal
t = 0:pi/100:40;
x = sin(pi/10*t);
subplot(3,1,1);
figure(1);
grid on;
plot(t,x);
title('Sinusoidal signal without noise')
xlabel('t');
ylabel('x(t)');

%adding noise using rand function
noise = 0.5*randn(size(t));
x_withnoise = x + noise;
subplot(3,1,2);
figure(1);
plot(t,x_withnoise);
title('Sinusoidal signal with noise')
xlabel('t');
ylabel('x(t)');

%using LPF with hamming window to filter out the noise
%wn=[wp wst]; %range of frequencies
fil_order = 64; %order of the filter
wc = (wst + wp)/2;

%designing the digital LPF with hamming window
filt = designfilt('lowpassfir','FilterOrder',fil_order,'CutoffFrequency',wc,'SampleRate',10000,'DesignMethod','window','Window','hamming');

%applying window on noisy signal
h = filter(filt,x_withnoise);

subplot(3,1,3);
figure(1);
plot(t,h);
title('Output singal after applying filter and window');
xlabel('t');
ylabel('h(t)');

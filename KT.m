% Author: Li Li
% Date: 2018-01-20
% Description: A simple Matlab script demo of Kurtosis function
% Calls: fget_sac, sac, sachdr 
% Input: Three component data of event waveform with SAC format and same length 
% Output: Display original waveform and function
% Return: None
% Others: base on Matlab script fget_sac.m, sac.m, sachdr.m which come from Professor Zhigang Peng.

file_e = '2013.061.18.30.14.7900.YN.EYA.00.BHE.D.SAC'
file_n = '2013.061.18.30.14.7900.YN.EYA.00.BHN.D.SAC'
file_z = '2013.061.18.30.14.7900.YN.EYA.00.BHZ.D.SAC'
[t,UE,Ehdr] = fget_sac(file_e);
[t,UN,Nhdr] = fget_sac(file_n);
[t,UZ,Zhdr] = fget_sac(file_z);
evlo = Zhdr.event.evlo;
evla = Zhdr.event.evla;
evdp = Zhdr.event.evdp;
stlo = Zhdr.station.stlo;
stla = Zhdr.station.stla;
stel = Zhdr.station.stel;
dist = Zhdr.evsta.dist; 
t0 = Zhdr.times.t0;
t1 = Zhdr.times.t1;
dt = Zhdr.times.delta;
theta = Zhdr.evsta.az/180*pi;
evdp = evdp+stel/1000;
% remove mean
UE = UE-mean(UE);
UN = UN-mean(UN);
UZ = UZ-mean(UZ);

trsize = size(UZ);
cf = ones(trsize);
ktw = 1.;
wn = round(ktw/dt);
for i = wn:length(UZ)
    cf(i) = kurtosis(UZ(i-wn+1:i));
end

xliml = t0 - 5.;
xlimr = t0 + 10.;
subplot(211);
plot(t, UZ);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('Original Waveform');

subplot(212);
plot(t, cf);

xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('Kurtosis');


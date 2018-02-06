% Author: Li Li
% Date: 2018-01-20
% Description: A simple Matlab script demo of Allen's STA/LTA
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

k = 3;
sw = 0.2;
lw = 3.0;
swnpts = round(sw/dt);
lwnpts = round(lw/dt);

trsize = size(UZ);
cf = zeros(trsize);
stalta = ones(trsize);
% cf = y(i)^2 + k(y(i) - y(i-1))^2
cf(2:trsize) = UZ(2:trsize).^2 + k*((UZ(2:trsize)-UZ(1:trsize-1)).^2);
cf(1) = cf(2);
for i = lwnpts:trsize
    stalta(i) = mean(cf(i-swnpts+1:i)) / mean(cf(i-lwnpts+1:i));
end
xliml = t0 - 5.;
xlimr = t0 + 10.;
subplot(211);
plot(t, UZ);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('Original Waveform');

subplot(212);
plot(t, stalta);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('STA/LTA');

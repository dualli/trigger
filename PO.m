% Author: Li Li
% Date: 2018-01-20
% Description: A simple Matlab script demo of Polerization Analysis for filter P and S
% Calls: fget_sac, sac, sachdr 
% Input: Three component data of event waveform with SAC format and same length 
% Output: Display original waveform and function
% Return: None
% Others: base on Matlab script fget_sac.m, sac.m, sachdr.m which come from Professor Zhigang Peng.

file_e = '2013.061.18.30.14.7900.YN.EYA.00.BHE.D.SAC';
file_n = '2013.061.18.30.14.7900.YN.EYA.00.BHN.D.SAC';
file_z = '2013.061.18.30.14.7900.YN.EYA.00.BHZ.D.SAC';
[t, UE, Ehdr] = fget_sac(file_e);
[t, UN, Nhdr] = fget_sac(file_n);
[t, UZ, Zhdr] = fget_sac(file_z);
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
pfw = ones(trsize);
sfw = ones(trsize);

pow = 2.;
wn = round(pow/dt);

for i = wn:length(UZ)
    true = UE(i-wn+1:i) - mean(UE(i-wn+1:i));
    trun = UN(i-wn+1:i) - mean(UN(i-wn+1:i));
    truz = UZ(i-wn+1:i) - mean(UZ(i-wn+1:i));
    trcov = cov([true, trun, truz]);
    [v, dg] = eig(trcov, 'vector');
    rtl = 1 - (dg(1) + dg(2)) / (2 * dg(3));
    pfw(i) = rtl * abs(v(3, 3));
    sfw(i) = rtl * (1 - abs(v(3, 3)));
end

xliml = t0 - 3.;
xlimr = t0 + 8.;

subplot(411);
plot(t, UE, 'LineWidth', 1.5);
hold;
plot(t, sfw.*UE, 'LineWidth', 1.5);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('BHE');

subplot(412);
plot(t, UN, 'LineWidth', 1.5);
hold;
plot(t, sfw.*UN, 'LineWidth', 1.5);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('BHN');

subplot(413);
plot(t, UZ, 'LineWidth', 1.5);
hold;
plot(t, pfw.*UZ, 'LineWidth', 1.5);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('BHZ');

subplot(414);
plot(t, pfw, 'LineWidth', 1.5);
hold;
plot(t, sfw, 'LineWidth', 1.5);
xlim([xliml xlimr]);
xlabel('Time / s');
ylabel('Filter');


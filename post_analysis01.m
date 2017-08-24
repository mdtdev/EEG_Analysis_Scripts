x=pop_loadset();
len=x.pnts;
d=x.data;
channel=7;
Fs=128;
m=7680;
startpoints=1:m:len;

vp=[];
for k= startpoints(1:end-1);
    b=bandpower(d(channel, k:(k+m)),Fs,[8 13])/ bandpower(d(channel, k:(k+m)), Fs, [1 41]);
    vp=[vp b]
end

plot(startpoints(1:(end-1))/m,vp)



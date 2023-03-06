
function  IsTonal(signal)

[audio1,fs]=audioread(signal);
tonal=0;
nontonal=0;
N=length(audio1);
audiol=audio1(:,1);
%audior=audio1(:,2);
t=(0:N-1)/fs;
NFFT=2048;
fHz=0:fs/NFFT:fs/2;

if mod((ceil(N/fs)),2) == 0
    td=ceil(N/fs);
else
    td=ceil(N/fs)+1;

end 
for i=0:(td-2)/2
    
    clip=audiol(t>i*2 & t<(i*2)+2);
    clip=clip/max(clip);
    %--
    Nclip=length(clip) ;
    fss=[];

    window=rectwin(NFFT)/sum(rectwin(NFFT));
    columnas=ceil(Nclip/NFFT);
    totals=columnas*NFFT;
    if totals > Nclip
       s0=[clip; zeros(totals-Nclip,1)];
    else
       s0=clip;
    end
    ss=reshape(s0,NFFT,columnas);

    for indc=1:columnas
        wseg1=ss(:,indc).*window  ;
        fss=[fss abs(fft(wseg1,NFFT))];
    end
    nfss=fss(1:NFFT/2+1,:);
    output=mean(nfss,2);   
    %--
   
    outputdb=20*log10(output); 
    threshold = 0.61*mean(outputdb(fHz<10000));
    threshold2 = 0.61*mean(outputdb(fHz>10000 & fHz<20000));
    %figure;
    %plot(fHz,20*log10(output)),axis([0 20000 -90 10]);
    %yline(threshold)

    M= max(findpeaks(outputdb(fHz<20000)));

    if ((M > threshold) || (M > threshold2))
        tonal=tonal+1;
    else 
        nontonal=nontonal+1;    
    end

end




if (1.5*tonal>nontonal) 
    fprintf("True")
else
    fprintf("False")
end

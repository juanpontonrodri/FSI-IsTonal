function output = view_spec(signal,windowopt,Nfft,fs,option)

% function view_spec(senal,ventana,Nfft,fs,option)
%
%  This function computes and shows the spectrum of a signal.
% 
%   view_spec(signal,window,Nfft,fs);
% 
% INPUT:
%   signal  :   signal whose spectrum is calculated.
%   windowopt  :   selection of window used (no overlapping)
%               options:  'rectangular', 'hamming', 'hanning'
%   Nfft    :   window length and Number of fft points . 
%   fs      :   sampling frequency 
%   Option  :   1 for linear and 2 for semilog axis. 
% OUTPUT:
%   No output values. The function shows the signal and its spectrum.
% See also fft, hanning, hamming

Nsenal=length(signal);  %Total de muestras de la señal
Ts=1/fs;
t=0:Ts:Ts*(Nsenal - 1);
fss=[];

switch windowopt
    case 'rectangular'
       window=rectwin(Nfft);
    case 'hanning'
       window=hanning(Nfft);
    case 'hamming'
        window=hamming(Nfft);
end

window=window/sum(window); %Normalización para que W(f=0)=1

%reordenamos el vector de datos en una matriz de 
columnas=ceil(Nsenal/Nfft);
totals=columnas*Nfft;
if totals > Nsenal 
       s0=[signal; zeros(totals-Nsenal,1)];
else
       s0=signal;
end
ss=reshape(s0,Nfft,columnas);

%enventanamos y calculamos la fft de cada columna de la matriz de datos
for indc=1:columnas
  wseg1=ss(:,indc).*window;  
  fss=[fss abs(fft(wseg1,Nfft))];  %normalizada la amplitud de la fft??
end

%nos quedamos con las frecuencias entre 0 y pi
nfss=fss(1:Nfft/2+1,:);

%calculamos la media
mfss=mean(nfss,2);
fHz=0:fs/Nfft:fs/2;
if option ==1
subplot(211), plot(t,signal), xlabel('t (s)'), ylabel('amplitud'), axis tight;
subplot(212), plot(fHz,20*log10(mfss)), xlabel('f (Hz)'), ylabel('Magnitud (dB)'),axis([0 10000 -90 10]);
else
subplot(111), semilogx(fHz,20*log10(mfss)), xlabel('f (Hz)'), ylabel('Magnitud (dB)'),axis([0 fs/2 -60 10]);
grid;
end
output =mfss;
end

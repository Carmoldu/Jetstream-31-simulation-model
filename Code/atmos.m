function  [p,t] = atmos(h)
% This function determines the ISA properties
% based on the altitude given in metres
% Written by A K Cooke - 3 Nov 04, modified 24 Jan 08

    if h < 11000
        t = 288.15 - 0.0065 * h;
        p = (8.9619638 - 0.00020216125 * h)^5.2558797;
    elseif h < 20000
        t = 216.25;
        p = 128244.5 * exp(-0.00015768852 * h);
    elseif h < 32000
        t = 196.65 + 0.0010 * h;
        p = (0.70551848 + 0.0000035876861 * h)^-34.163218;
    else
        t = 139.05 + 0.0028 * h;
        p = (0.34926867 + 0.0000070330980 * h)^-12.201149;
    end
return

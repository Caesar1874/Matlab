function rlt = ShiftMod(src, mode)
rlt = mod(src, mode);
rlt(rlt == 0) = mode;
function R = getRMatrix2(y0, yDir)
% function R = getRMatrix2(y0, yDir)
% Computes a rotation matrix to transform y0 to yDir,
% while trying to keep the rotation axis perpendicular to the 
% direction of gravity.

% AUTORIGHTS

  R1 = getRMatrix(y0, yDir);
  zNew = R1*[0 0 1]';
  zNew(2) = 0; zNew = zNew./norm(zNew);
  R2 = getRMatrix(zNew, [0 0 1]');
  R = R2*R1;
end  

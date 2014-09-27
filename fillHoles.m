function z = fillHoles(z, typ)
% function z = fillHoles(z, typ)
% Input: 
%   z depth image
%   typ = ['recursive-dilate'], 'bwdist'
%     'recursive-dilate': recursively dilates and puts the closest point 
%     'bwdist': find the closest point in the known pixels and copy the value from there.

% AUTORIGHTS

  if(~exist('typ', 'var'))
    typ = 'recursive-dilate';
  end

  switch typ,

  case 'recursive-dilate',
    z0 = z;
    [h w] = size(z);
    z(isnan(z)) = inf;
    count = sum(isinf(z(:)));
    se = strel([1 1 1; 1 1 1; 1 1 1]);
    % se = strel('square', 3);
    while(count > 0),
      zf = -imdilate(-z, se);
      z(isinf(z)) = zf(isinf(z));
      count = sum(isinf(z(:)));
    end

  case 'bwdist',
    z0 = z;
    [h w] = size(z);
    [d, ind] = bwdist(~isnan(z), 'cityblock');
    z(isnan(z)) = z(ind(isnan(z)));

  end
end

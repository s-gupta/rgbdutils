function out = jointBilateral(refI, I, sigma1, sigma2, tmpDir, binName)
% function out = jointBilateral(refI, I, sigma1, sigma2, tmpDir, binName)

% AUTORIGHTS

  tt = tic();
  MEX = true; FILE = false; DISP = false;
  binName = '~/psi/work3/sgupta/eccv14/eccv14-code/imagestack/bin/ImageStack';
  % MEX = false; FILE = true; DISP = false;
  % MEX = true; FILE = true; DISP = true;
  if MEX,
	  refII = permute(refI, [4 3 2 1]);
    II = permute(I, [4 3 2 1]);
    aa = joint_bilateral_mex(single(II), single(refII), sigma1, sigma2);
    out = double(permute(aa, [4 3 2 1]));
    out2 = out;
    % keyboard
  end

  if FILE
    if(~exist('tmpDir', 'var'))
      tmpDir = '/dev/shm/';
    end

    if(~exist('binName', 'var'))
      binName = '/work4/sgupta/tmp/splitBias/piotr/release/ng/ImageStack';
    end

    % out = I; return;

    assert(isa(refI, 'double'))
    assert(isa(I, 'double'));
    
    % Generate two filenames
    r = randsample(100000, 3, false);
    pid = getPID();
    for i = 1:3,
      %f{i} = fullfile('/tmp', sprintf('sgupta-imageStack-%07d-%06d.tmp', pid, r(i)));
      f{i} = fullfile(tmpDir, sprintf('sgupta-imageStack-%07d-%06d.tmp', pid, r(i)));
    end
      
    refII = isWrite(refI, f{1});
    II = isWrite(I, f{2});
    
    % Run Joint Bilateral Filtering
    % str = sprintf('%s -load %s -load %s -jointbilateral %2.6f %2.6f -save %s double  > /dev/null', binName, f{1}, f{2}, sigma1, sigma2, f{3});
    str = sprintf('time %s -load %s -load %s -time --jointbilateral %2.6f %2.6f -save %s double', binName, f{1}, f{2}, sigma1, sigma2, f{3});
    [a, b] = system(str);
    b = regexp(b, '\n', 'split'); b = str2num(b{5}(1:5));
    if(a ~= 0)
      % For some reason the bilateral filtering library crashes on some inputs!!
      maxRefI = prctile(linIt(refI(:,:,4)), 98);
      refI(:,:,4) = min(refI(:,:,4), maxRefI);
      out = jointBilateral(refI, I, sigma1, sigma2);
    else
      % Read back the results
      out = isRead(f{3});
    end

    %Remove these files?
    for i = 1:3,
      str = sprintf('rm %s &', f{i});
      system(str);
    end
    fprintf(' joint bilateral matlab overhead time: %0.3f\n', toc(tt)-b);
  end

  if DISP && MEX && FILE
    err = norm(out(:) - out2(:))./norm(out(:));
    disp(err);
  end
end

function a = getPID()
  a = 1;
end

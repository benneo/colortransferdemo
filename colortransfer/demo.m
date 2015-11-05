clear all; clc;

pd = 'test/exam2/';
src_path = [pd 'src.png'];
ref_path = [pd 'ref.png'];
ini_path = [pd 'tgt.png'];
save_path = [pd 'rst.png'];

% %if needed, use state-of-the-art method (histogram matching) to produce initial image
% src = imread(src_path);
% ref = imread(ref_path);
% ini = ColorTransferPT(src,ref);
% imwrite(ini, ini_path);

disp('Loading source, reference and initial images ...');
src = imread(src_path);
ref = imread(ref_path);
ini = imread(ini_path);
s = double(src)/255;
f = double(ref)/255;
r = double(ini)/255;

disp('Starting fidelity refinement for color transfer ...');
tic;
rst = FidelityRefinement(s,f,r,[]);
toc;

imshow([s,r,rst]);

disp('Saving refined result ...');
imwrite(rst, save_path);


disp('Starting evaluation using gamut distance and structure PSNR ...');
Is = im2double(imread(src_path));
It = im2double(imread(ref_path));
Ix = im2double(imread(ini_path));
Io = im2double(imread(save_path));

% % compute gamut distance
dx = evaluate_metric(It, Ix);
do = evaluate_metric(It, Io);

disp(['Gamut Distance between initial image and reference image: ' num2str(dx)]);
disp(['Gamut Distance between refined result and reference image: ' num2str(do)]);


% % compute structure PSNR
psnr_x = compute_psnr(Ix, Is);
psnr_o = compute_psnr(Io, Is);

disp(['Structure PSNR between initial image and source image: ' num2str(psnr_x)]);
disp(['Structure PSNR between refined result and source image: ' num2str(psnr_o)]);

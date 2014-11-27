%Rafael C.P. 2014 - rcpinto@inf.ufrgs.br - http://www.inf.ufrgs.br/~rcpinto
%makeSprite: Generates a new random sprite based on a list of existing sprites
function [sprite,m,v,h,w,c] = makeSprite(varargin)
    if nargin == 1		%if there is only 1 input argument (a cell array of image paths)
        list = varargin{1};	%the list is the first and only argument
        l = length(list);	%how many images in the list
        ims = [];		%initialize empty images matrix
        for i = 1:l		%for each image
            im = imread(list{i});	%reads current image into 'im'
            [h,w,c] = size(im);		%gets height, width and number of channels for current image
            d = h*w*c;			%number of values (dimensions) to store
            im_ = im(:);		%linearization of current image (a vector)
            ims(i,:) = double(im_);	%appends current image as a new line to the ims matrix
        end;
        ims = repmat(ims, [ceil(d/l) 1]);	%generates a lot of copies of provided images so the system has more equations than variables
        ims = ims + 20 * randn(size(ims));	%adds Gaussian noise to them (this is a kind of regularization)
        m = mean(ims);				%gets the mean image from the list
        errors = bsxfun(@minus,ims,m);		%gets the difference between every image on the list from the mean
        v = errors' * errors / size(ims,1);	%computes the covariance matrix
        v = 0.999*v + 0.001*diag(diag(v));	%a bit more regularization
    end;
    if nargin == 5	%if there are 5 input arguments
        m = varargin{1};	%gets a precomputed mean from the first argument
        v = varargin{2};	%gets a precomputed covariance matrix from the second argument
        h = varargin{3};	%gets the image height from the third argument
        w = varargin{4};	%gets the image weight from the fourth argument
        c = varargin{5};	%gets the number of channels from the fifth argument
    end;
    sprite = uint8(reshape(mvnrnd(m,v),[h w c]));	%generates the new sprite as a sample point from the multivariante normal distribution with mean m and covariance matrix m
    if nargout == 0	%if the function result was not assigned to anything
        imshow(sprite);	%show the resulting sprite
    end;

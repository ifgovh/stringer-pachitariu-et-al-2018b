function smooth_code_img_2_ExtCurrent(mean_curr,type,varargin)
netsz = 63;
neurons = 1:netsz*netsz;
end_step = 4*10^8;
start_step = 0.4*10^5;
path = '/import/headnode1/gche4213/Project4/exp_data/';
for i = 1:length(varargin)/2
    var_name = varargin{2*i-1};
    var_value = varargin{2*i};
    if isnumeric(var_value)
        eval([var_name, '=', num2str(var_value), ';']);
    else
        eval([var_name, '=''', var_value, ''';']);
    end
end

switch type
    case '4D'        
        % determin the boundary of real value
        % A = false(68,270);
        % for ii=1:2800
        %     A=(imgs(:,:,ii)<128) | A;
        % end
        % imagesc(A)
        % [x,y] = ginput(2);
        load(fullfile(path,'images_natimg2800_4D_M170717_MP033_2017-09-22.mat'))
        for ii = 1:size(imgs,3)
            frame = imresize(imcrop(imgs(:,:,ii),[53,1,90,68]),[63,63]);
            % normalize to [0 1]
            frame=mat2gray(frame);
            
            curr = reshape(frame,1,netsz*netsz);
            
            fname=[type,num2str(ii),'_',num2str(mean_curr),'_',num2str(netsz),'x',num2str(netsz),'_E.h5']; % ***** change the filename if using a different dataset
            hdf5write(fname,'/current',[curr;curr]');
            hdf5write(fname,'/neurons',int32([neurons;neurons]'),'WriteMode','append');
            hdf5write(fname,'/frame_rate',1,'WriteMode','append');
            hdf5write(fname,'/mean_curr',mean_curr,'WriteMode','append');
            hdf5write(fname,'/end_step',end_step,'WriteMode','append');
            hdf5write(fname,'/start_step',start_step,'WriteMode','append');
        end
    case '8D'
        % determin the boundary of real value
        % A = false(68,270);
        % for ii=1:2800
        %     A=(imgs(:,:,ii)<128) | A;
        % end
        % imagesc(A)
        % [x,y] = ginput(2);
        load(fullfile(path,'images_natimg2800_8D_M161025_MP030_2017-06-07.mat'))
        for ii = 1:size(imgs,3)
            frame = imresize(imcrop(imgs(:,:,ii),[70,1,90,68]),[63,63]);
            % normalize to [0 1]
            frame=mat2gray(frame);
            
            curr = reshape(frame,1,netsz*netsz);
            
            
            fname=[type,num2str(ii),'_',num2str(mean_curr),'_',num2str(netsz),'x',num2str(netsz),'_E.h5']; % ***** change the filename if using a different dataset
            hdf5write(fname,'/current',[curr;curr]');
            hdf5write(fname,'/neurons',int32([neurons;neurons]'),'WriteMode','append');
            hdf5write(fname,'/frame_rate',1,'WriteMode','append');
            hdf5write(fname,'/mean_curr',mean_curr,'WriteMode','append');
            hdf5write(fname,'/end_step',end_step,'WriteMode','append');
            hdf5write(fname,'/start_step',start_step,'WriteMode','append');
        end
    case 'origin'
        load(fullfile(path,'images_natimg2800_all.mat'))
        for ii = 1:size(imgs,3)
            frame = imresize(imcrop(imgs(:,:,ii),[91,1,90,68]),[63,63]);
            
            % DoG filter
            h1 = imgaussfilt(frame,1);
            h2 = imgaussfilt(frame,2);
            frame = h1-h2;            
            
            % decay the boundary to make up the PBC
            gw=gausswin(10);
            gw=gw';
            right = repmat(gw(6:10),size(frame,1),1);
            frame(:,end-4:end) = double(frame(:,end-4:end)).*right;
            left = repmat(gw(1:5),size(frame,1),1);
            frame(:,1:5) = double(frame(:,1:5)).*left;            
            gw=gausswin(10);
            up = repmat(gw(1:5),1,size(frame,2)-10);
            down = repmat(gw(6:10),1,size(frame,2)-10);            
            frame(end-4:end,6:58) = double(frame(end-4:end,6:58)).*down;            
            
            % normalize to [0 1]
            frame=mat2gray(frame);
            
            curr = reshape(frame,1,netsz*netsz);
            
            fname=[type,num2str(ii),'_',num2str(mean_curr),'_',num2str(netsz),'x',num2str(netsz),'_E.h5']; % ***** change the filename if using a different dataset
            hdf5write(fname,'/current',[curr;curr]');
            hdf5write(fname,'/neurons',int32([neurons;neurons]'),'WriteMode','append');
            hdf5write(fname,'/frame_rate',1,'WriteMode','append');
            hdf5write(fname,'/mean_curr',mean_curr,'WriteMode','append');
            hdf5write(fname,'/end_step',end_step,'WriteMode','append');
            hdf5write(fname,'/start_step',start_step,'WriteMode','append');
        end
end

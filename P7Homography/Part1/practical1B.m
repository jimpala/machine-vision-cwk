function practical1B

%the aim of the second part of practical 1 is to use the homography routine
%that you established in the first part of the practical.  We are going to
%make a panorama of several images that are related by a homography.  I
%provide 3 images (one of which is has a large surrounding region) and a
%matching set of points between these images.

%close all open figures
close all;

%load in the required data
load('PracticalData','im1','im2','im3','pts1','pts2','pts3','pts1b');
%im1 is center image with grey background
%im2 is left image 
%pts1 and pts2 are matching points between image1 and image2
%im3 is right image
%pts1b and pts3 are matching points between image 1 and image 3

%show images and points
figure; set(gcf,'Color',[1 1 1]);image(uint8(im1));axis off;hold on;axis image;
plot(pts1(1,:),pts1(2,:),'r.'); 
plot(pts1b(1,:),pts1b(2,:),'m.');
figure; set(gcf,'Color',[1 1 1]);image(uint8(im2));axis off;hold on;axis image;
plot(pts2(1,:),pts2(2,:),'r.'); 
figure; set(gcf,'Color',[1 1 1]);image(uint8(im3));axis off;hold on;axis image;
plot(pts3(1,:),pts3(2,:),'m.'); 
drawnow

%****TO DO**** 
%calculate homography from pts1 to pts2
H = calcBestHomography(pts1,pts2);

%****TO DO**** 
%for every pixel in image 1
    %transform this pixel position with your homography to find where it 
    %is in the coordinates of image 2
    %if it the transformed position is within the boundary of image 2 then 
        %copy pixel colour from image 2 pixel to current position in image 1 
        %draw new image1 (use drawnow to force it to draw)
    %end
%end;

figure(1);

for pixY = 1:size(im1,1)
    for pixX = 1:size(im1,2)
        hPixHomo = H * [pixX, pixY, 1]';
        hPixCart = hPixHomo / hPixHomo(3);
        hPixX = round(hPixCart(1)); %round off
        hPixY = round(hPixCart(2));
        if hPixX >= 1 && hPixX <= size(im2,2) && ...
                hPixY >= 1 && hPixY <= size(im2,1)
            im1(pixY,pixX,:) = im2(hPixY,hPixX,:);          
        end
    end
end

image(uint8(im1))
drawnow

%****TO DO****
%repeat the above process mapping image 3 to image 1.

H = calcBestHomography(pts1b,pts3);

%****TO DO**** 
%for every pixel in image 1
    %transform this pixel position with your homography to find where it 
    %is in the coordinates of image 2
    %if it the transformed position is within the boundary of image 2 then 
        %copy pixel colour from image 2 pixel to current position in image 1 
        %draw new image1 (use drawnow to force it to draw)
    %end
%end;

for pixY = 1:size(im1,1)
    for pixX = 1:size(im1,2)
        hPixHomo = H * [pixX, pixY, 1]';
        hPixCart = hPixHomo / hPixHomo(3);
        hPixX = round(hPixCart(1)); %round off
        hPixY = round(hPixCart(2));
        if hPixX >= 1 && hPixX <= size(im2,2) && ...
                hPixY >= 1 && hPixY <= size(im2,1)
            im1(pixY,pixX,:) = im3(hPixY,hPixX,:);
        end
    end
end

image(uint8(im1))
drawnow

%==========================================================================
function H = calcBestHomography(pts1Cart, pts2Cart)

%should apply direct linear transform (DLT) algorithm to calculate best
%homography that maps the points in pts1Cart to their corresonding matchin in 
%pts2Cart

%****TO DO ****: replace this


%**** TO DO ****;
%first turn points to homogeneous
%then construct A matrix which should be (10 x 9) in size
%solve Ah = 0 by calling
%h = solveAXEqualsZero(A); (you have to write this routine too - see below)
pts1Homo = [pts1Cart; ones(1,size(pts1Cart,2))];
pts2Homo = [pts2Cart; ones(1,size(pts1Cart,2))];

A = [];

for cx = 1:size(pts1Cart,2)
    cA_1 = [zeros(3,1), pts1Homo(:,cx)];
    cA_2 = [-1 * pts1Homo(:,cx), zeros(3,1)];
    cA_3 = [pts2Homo(2,cx) * pts1Homo(:,cx), ...
        -pts2Homo(1,cx) * pts1Homo(:,cx)];
    cA_T = vertcat(cA_1,vertcat(cA_2,cA_3));
    cA = cA_T';
    A = vertcat(A,cA);
end

h = solveAXEqualsZero(A);

%reshape h into the matrix H

H = reshape(h,3,3)';


%Beware - when you reshape the (9x1) vector x to the (3x3) shape of a homography, you must make
%sure that it is reshaped with the values going first into the rows.  This
%is not the way that the matlab command reshape works - it goes columns
%first.  In order to resolve this, you can reshape and then take the
%transpose


%==========================================================================
function x = solveAXEqualsZero(A);

%****TO DO **** Write this routine

[U,L,V] = svd(A);
x = V(:,9);

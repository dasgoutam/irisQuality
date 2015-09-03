%read the image (may be in rgb or grayscale)
img=imread('C:\Users\hcilab\Downloads\10.bmp');
%convert to graysacle and then to double
im1=rgb2gray(img);
im1=im2double(im1);

%Pre-processing
%remove regions of light reflections

%1-complement the image
im2=imcomplement(im1);
%2-fill in the holes\
im2=imfill(im2,'holes');
%3-complement back to original
im2=imcomplement(im2);

%enhance contrast of image using histogram equalization
im3=histeq(im2);

%apply Daugman's integrodifferential operator
%use the thresh function
rimin=80;%minimum radius of the iris
rimax=120;%maximum radius of the iris
[ci,cp,o]=thresh(im3,rimin,rimax);
imshow(o);

%we get two concentric circles i.e the iris-pupil and iris-sclera boundary
%Extraction of the required area from the image
%iris center and radius
xi=ci(1);
yi=ci(2);
ri=ci(3);
%pupil center and radius
xp=cp(1);
yp=cp(2);
rp=cp(3);

%check if the coordinates of the image are in the concentric circles formed
%or not. Only consider those coordinates which are inside this area.
[si,sj]=size(im1);
I=zeros(si,sj);
for i=1:si
    for j=1:sj
        if (i-xi).^2 + (j-yi).^2 < ri.^2 && (i-xp).^2 + (j-yp).^2 > rp.^2
            I(i,j)=im1(i,j);
        end
    end
end
%final extracted iris
figure;imshow(I,[]);
I1=I((xi-ri):(xi+ri),(yi-ri):(yi+ri));

%testing
imR=I1;
rMin=0.4;
rMax=1;
M=64;
N=256;
imP = ImToPolar(imR ,rMin, rMax ,M, N);
figure;
imshow(imP,[]);

[r c]=size(imP);
title('Normalized');
E=imP;

for i=1:r
    count=0;
    for j=1:c
        if E(i,j)~=0 
        count=count+1;
        end
        row(i)=count;
    end
end

% for i=1:c
%     count=0;
%     for j=1:r
%         if E(j,i)>=1
%         count=count+1;
%         end
%         col(i)=count;
%     end
% end
flag=0;
for i=1:r
    if flag==0 & row(i)>=40
        
        x1=i;
        flag=1;
    end
%     if flag==1 & row(i)>=1
%         x2=i;
     end

%figure;
E1=(E(x1:r,1:c));
%imshow(E1,[]);
% fname=strcat('D:\test\Result\',num2str(inew),'\',num2str(jnew),'.mat');
% save(fname,'E1');
[rE cE]=size(E1);
CW=zeros(size(E1));
for i= 1:cE
    for j=1:rE 
      CW(1:j,i)=dct(E1(1:j,i));
      M(1,j)=max(CW(1:j,i));
    end
     M1(1,i)=max(M);
end
a=1:1:200;
% figure;

%Q=plot(a,M1,':r.');
%hold on;


%testing 2d haar wavelet
[a,h,v,d]=dwt2(E,'haar');
[a1,h1,v1,d1]=dwt2(a,'haar');
[a2,h2,v2,d2]=dwt2(a1,'haar');
[a3,h3,v3,d3]=dwt2(a2,'haar');
[a41,h4,v4,d4]=dwt2(a3,'haar');
a41;
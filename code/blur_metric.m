%Estimation of blur using Min Goo Choi et al. method
img=imread('/home/goutam/iris/IITD_Database/003/01.bmp'); %read the image
img=im2double(img);
%f1=fspecial('gaussian',11,5);
%img=conv2(img,f1);
%calculation of the Horizontal Absolute Difference Value(HADV)
[r c]=size(img);
dh=zeros(r,c);
for i=1:r
  for j=2:c-1
    dh(i,j)=abs(img(i,j+1)-img(i,j-1));
  end
end
%calculation of the horizontal mean
dh_mean=mean(mean(dh));
%calculation for ch(x,y) i.e.the candidates for the edge pixels
%ch(x,y) will be equal to to dh(x,y) if dh(x,y) is greater than dh_mean
ch=zeros(r,c);
for i=1:r
  for j=2:c-1
    if dh(i,j) > dh_mean
      ch(i,j)=dh(i,j);
    end
  end
end
%detecting the horizontally edge pixels
%eh(x,y) is if it is greater than the horizontally adjacent pixels
eh=zeros(r,c);
for i=1:r
  for j=2:c-1
    if ch(i,j) > ch(i,j-1) && ch(i,j) > ch(i,j+1)
      eh(i,j)=1;
    end
  end
end
%calculation of blur, horizontal and vertical
ah=zeros(r,c);brh=zeros(r,c);
av=zeros(r,c);brv=zeros(r,c);
for i=2:r-1
  for j=2:c-1
    ah(i,j)=0.5*abs((img(i,j+1)-img(i,j-1)));
    av(i,j)=0.5*abs((img(i-1,j)-img(i+1,j)));
    if ah(i,j)==0
      brh(i,j)=abs(img(i,j)-ah(i,j));
    else
      brh(i,j)=abs(img(i,j)-ah(i,j))/ah(i,j);
    end
    if av(i,j)==0
      brv(i,j)=abs(img(i,j)-av(i,j));
    else
      brv(i,j)=abs(img(i,j)-av(i,j))/av(i,j);
    end
  end
end
B=zeros(r,c);
%threshold value
T=0.1;
for i=1:r
  for j=1:c
    if max(brh(i,j),brv(i,j)) < T
      B(i,j)=1;
    end
  end
end
ep=sum(sum(eh));bp=sum(sum(B));
ratio=bp/ep
function [B]=my_otele(A,n1,n2)
[w,h]=size(A);
B=zeros(w,h);
for i=n1:w
for j=n2:h
B(i,j)=A(i-n1+1,j-n2+1);
end
end

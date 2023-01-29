function F=PCA(feat)
%PCA calculation
E = Eigen_Build(feat);
E = Eigen_Deflate(E,3);


F=E;
return
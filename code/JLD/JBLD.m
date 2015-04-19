function [ J ] = JBLD( G1,G2)
%Fast computation of the Jensen-Bregman LogDet Divergence
%of two Symmetric PD matrices.
%Created by Octavia Camps, April 1, 2015

J = logdet(0.5 * (G1+G2)) - 0.5 * logdet(G1) - 0.5 * logdet(G2);
% J = logdet(0.5 * (G1+G2)) - 0.5 * logdet(G1*G2);


end


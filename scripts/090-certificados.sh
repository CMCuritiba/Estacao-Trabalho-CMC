#!/bin/bash 
### Autor: Felipe Trindade de Oliveira ####
### Esse codigo baixa os certificados ICP direto do site e atualiza automaticamente para o Firefox e Google ###


sudo apt-get install	    	ca-certificates;
mkdir -p			            /usr/share/ca-certificates/icp-brasil;
cd				                /usr/share/ca-certificates/icp-brasil;
wget --no-check-certificate 	http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip;
unzip				            ACcompactado.zip;
rm -rf				            ACcompactado.zip;
sudo 				            1update-ca-certificates;

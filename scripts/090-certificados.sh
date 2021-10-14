#!/bin/bash
### Autor: Felipe Trindade de Oliveira ####
### Esse codigo baixa os certificados ICP direto do site e atualiza automaticamente para o Firefox e Google ###

apt-get install ca-certificates

ICPDIR="/usr/share/ca-certificates/icp-brasil" # type: string dirname
ICPTMPZIP="/tmp/ACcompactado.zip" # type: string full path
ICPURL="http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip" # type: string URL
mkdir -p "$ICPDIR"

if wget --no-check-certificate --quiet "$ICPURL" -O "$ICPTMPZIP"; then
    unzip "$ICPTMPZIP" -d "$ICPDIR"
    update-ca-certificates
else
    logger "Erro ao realizar download dos certificados ICP."
fi

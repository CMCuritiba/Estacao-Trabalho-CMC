#!/bin/bash

# Coloca opção no arquivo base do resolv
# Não testado, deve funcionar
# O resto deve ser gerado dinamicamente
if [ ! -d /etc/resolvconf ]; then
	mkdir /etc/resolvconf
fi

if [ ! -d /etc/resolvconf/resolv.conf.d ]; then
	mkdir /etc/resolvconf/resolv.conf.d
fi


echo "options timeout:1 attempts:1 rotate" > /etc/resolvconf/resolv.conf.d/base


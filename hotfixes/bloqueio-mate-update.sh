#!/bin/bash

# Se houver dif no grupo sudoers atualiza para dtic
if grep -w "dif" /etc/sudoers; then
	sed -i 's/%dif/%dtic/g' /etc/sudoers
fi
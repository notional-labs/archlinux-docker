FROM manjarolinux/base

RUN pacman -Syyu --noconfirm go base-devel git wget

RUN wget https://archive.evmos.org/mainnet/genesis.json

COPY ss.bash /ss.bash

EXPOSE 26656 26657 1317 9090 8545 8546

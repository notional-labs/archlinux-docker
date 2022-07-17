# This dockerfile will be used to bootstrap the docker changes for the cosmos SDK, and will be built hourly.
# We'll also move faddat/archlinux to an hourly schedule, ensuring that when the images are put to use, they dont' need to update as many packages.

FROM ghcr.io/notional-labs/archlinux

ENV GOPATH=/go

# everything needed for cosmos development
RUN pacman -Syyu --noconfirm go base-devel git leveldb rocksdb make python snappy lz4 git-lfs jq wget curl protobuf yarn rustup npm unzip

# Useful tools
RUN go install mvdan.cc/gofumpt@latest && \
      go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
      go install github.com/bufbuild/buf/cmd/buf@latest &&\
      go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
      go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
      go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v1.16.0 && \
      go install github.com/cosmos/cosmos-proto/cmd/protoc-gen-go-pulsar@latest && \
      git clone https://github.com/cosmos/cosmos-proto && \
      cd cosmos-proto && \
      go install ./... && \ 
      cp /go/bin/* /usr/bin && \
      rm -rf /go && \
      mkdir /go && \
      chmod -R 777 /go


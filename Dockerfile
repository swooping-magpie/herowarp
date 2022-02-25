####################################################################################################
## Builder
####################################################################################################
FROM docker.io/rust:latest AS builder

RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt install -y musl-tools musl-dev
RUN update-ca-certificates


WORKDIR /myherorust

COPY ./ .

RUN cargo build --target x86_64-unknown-linux-musl --release

####################################################################################################
## Final image
####################################################################################################
FROM docker.io/alpine:latest

WORKDIR /myherorust_runner

# copy the built file from builder
COPY --from=builder /myherorust/target/x86_64-unknown-linux-musl/release/herowarp ./


ENV PORT 4000
CMD ["/myherorust_runner/herowarp"]
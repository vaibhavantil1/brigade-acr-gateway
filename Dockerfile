FROM --platform=$BUILDPLATFORM brigadecore/go-tools:v0.6.0 as builder

ARG VERSION
ARG COMMIT
ARG TARGETOS
ARG TARGETARCH
ENV CGO_ENABLED=0

WORKDIR /
COPY . /
COPY go.mod go.mod
COPY go.sum go.sum

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build \
  -o bin/acr-gateway \
  -ldflags "-w -X github.com/brigadecore/brigade-foundations/version.version=$VERSION -X github.com/brigadecore/brigade-foundations/version.commit=$COMMIT" \
  .

FROM scratch
COPY --from=builder /bin/ /brigade-acr-gateway/bin/
ENTRYPOINT ["/brigade-acr-gateway/bin/acr-gateway"]

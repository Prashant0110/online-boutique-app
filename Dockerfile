FROM golang:1.26.2-alpine@sha256:f85330846cde1e57ca9ec309382da3b8e6ae3ab943d2739500e08c86393a21b1 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o frontend .

FROM alpine:3.22@sha256:310c62b5e7ca5b08167e4384c68db0fd2905dd9c7493756d356e893909057601

RUN adduser -D -u 10001 appuser

WORKDIR /app

COPY --from=builder /app/frontend .

COPY templates ./templates
COPY static ./static

USER 10001

EXPOSE 8080

CMD ["./frontend"]

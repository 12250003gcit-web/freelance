FROM docker.io/library/golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./

# Download dependencies inside the container instead of copying vendor
RUN go mod download

COPY . .
RUN go build -o main .

FROM docker.io/library/alpine:latest
WORKDIR /app
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/main .
CMD ["./main"]

FROM golang:1.20-alpine AS builder

RUN apk add --no-cache gcc g++ make libc-dev

WORKDIR /app

COPY go.mod main.go ./

RUN go mod tidy

COPY . .

RUN go build -v -o go-devops-assessment-webapp .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /app/go-devops-assessment-webapp .

EXPOSE 8080

CMD ["./go-devops-assessment-webapp"]

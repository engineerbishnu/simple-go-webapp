# Stage 1: Building Go Application
FROM golang:1.20-alpine AS builder

# Installing dependencies
RUN apk add --no-cache gcc g++ make libc-dev

# Setting up the working directory inside the container
WORKDIR /app

# Copy the Go module files (go.mod and go.sum) first to take advantage of Docker layer caching
COPY go.mod main.go ./

# Download dependencies
RUN go mod tidy

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o go-devops-assessment-webapp .

# Stage 2: Create the runtime image with only the compiled binary
FROM alpine:latest

# Install necessary certificates for the Go application to work (SSL/TLS)
RUN apk --no-cache add ca-certificates

# Set the working directory inside the container
WORKDIR /root/

# Copy the compiled binary from the builder stage
COPY --from=builder /app/go-devops-assessment-webapp .

# Expose the port that the app will run on
EXPOSE 8080

# Command to run the Go application
CMD ["./go-devops-assessment-webapp"]

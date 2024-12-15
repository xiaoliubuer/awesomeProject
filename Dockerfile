# Use the official Go image as a build environment
FROM golang:1.20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o main .

# Use a minimal base image for running the app
FROM alpine:latest

# Install CA certificates (necessary for HTTPS)
RUN apk --no-cache add ca-certificates

# Set the working directory
WORKDIR /root/

# Copy the compiled binary from the builder
COPY --from=builder /app/main .

# Expose the port your app runs on
EXPOSE 8080

# Command to run the application
CMD ["./main"]

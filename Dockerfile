# Use the official Golang image to build the initial executable
FROM golang:1.22.1 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download the dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the initial executable
RUN go build -o StationeersServerUI ./build.go

# Run the initial executable to build StationeersServerControl
RUN ./StationeersServerUI

# Verify that the resulting executable exists
RUN echo "Verifying the existence of StationeersServerControl executable:" && ls -l /app/StationeersServerControl*

# Use a minimal image to run the final application
FROM debian:bullseye-slim

# Install required libraries
RUN apt-get update && apt-get install -y lib32gcc-s1 && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the resulting executable from the builder stage
COPY --from=builder /app/StationeersServerControl* /app/

# Copy the UIMod directory
COPY --from=builder /app/UIMod /app/UIMod

# Expose the ports
EXPOSE 8080 27016

# Run the application
CMD ["./StationeersServerControl"]
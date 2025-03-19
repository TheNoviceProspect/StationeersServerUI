# Use the official Golang image to build the initial executable
FROM golang:1.22.1 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download the dependencies
RUN echo "Downloading dependencies..." && go mod download

# Copy the rest of the application source code
COPY . .

# Build the initial executable
RUN echo "Building StationeersServerUI..." && go build -o StationeersServerUI ./build.go

# Run the initial executable to build StationeersServerControl
RUN echo "Running StationeersServerUI to build StationeersServerControl..." && ./StationeersServerUI

# Verify that the resulting executable exists
RUN echo "Verifying the existence of StationeersServerControl executable:" && \
    if ls -l /app/StationeersServerControl*; then \
        echo "StationeersServerControl build successful."; \
    else \
        echo "Error: StationeersServerControl executable not found."; \
        exit 1; \
    fi

# Print the contents of the /app directory
RUN echo "Contents of /app directory after build:" && ls -l /app

# Use a minimal image to run the final application
FROM debian:bullseye-slim AS runner

# Install required libraries
RUN echo "Installing required libraries..." && apt-get update && apt-get install -y lib32gcc-s1 && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the resulting executable from the builder stage and rename it
COPY --from=builder /app/StationeersServerControl* /app/StationeersServerControl

# Verify that the executable was copied and renamed successfully
RUN echo "Verifying the copied and renamed StationeersServerControl executable:" && \
    if ls -l /app/StationeersServerControl; then \
        echo "StationeersServerControl copy and rename successful."; \
    else \
        echo "Error: StationeersServerControl executable not found after copy."; \
        exit 1; \
    fi

# Copy the UIMod directory
COPY --from=builder /app/UIMod /app/UIMod

# Expose the ports
EXPOSE 8080 27016

# Run the application
CMD ["/app/StationeersServerControl"]
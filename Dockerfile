# First stage: Build the Go application using the Golang image
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

# Second stage: Bootstrap the server using a Debian slim image
FROM steamcmd/steamcmd AS bootstrapper

# Set the working directory inside the container
WORKDIR /app

# Copy the initial executable from the builder stage
COPY --from=builder /app/StationeersServerUI /app/StationeersServerUI

# Copy the rest of the application source code
COPY --from=builder /app /app

# Install required libraries
#RUN echo "Installing required libraries..." && apt-get update && apt-get install -y \
#    lib32gcc-s1 \
#    libc6 \
#    && rm -rf /var/lib/apt/lists/*

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

# Third stage: Run the final application using the steamcmd/steamcmd image
FROM steamcmd/steamcmd:latest AS runner

# Set the working directory inside the container
WORKDIR /app

# Install required libraries
#RUN echo "Installing required libraries..." && apt-get update && apt-get install -y \
#    lib32gcc-s1 \
#    libc6 \
#    && rm -rf /var/lib/apt/lists/*

# Copy the resulting executable from the bootstrapper stage and rename it
COPY --from=bootstrapper /app/StationeersServerControl* /app/StationeersServerControl

# Verify that the executable was copied and renamed successfully
RUN echo "Verifying the copied and renamed StationeersServerControl executable:" && \
    if ls -l /app/StationeersServerControl; then \
        echo "StationeersServerControl copy and rename successful."; \
    else \
        echo "Error: StationeersServerControl executable not found after copy."; \
        exit 1; \
    fi

# Copy the UIMod directory
COPY --from=bootstrapper /app/UIMod /app/UIMod

# Expose the ports
EXPOSE 8080 27016

# Run the application and ensure proper handling of stdin, stdout, and stderr
CMD ["sh", "-c", "/app/StationeersServerControl < /dev/stdin > /dev/stdout 2> /dev/stderr"]
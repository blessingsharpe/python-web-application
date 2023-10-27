FROM alpine:latest

# Copy the entry point script into the container
COPY entrypoint.sh /entrypoint.sh

# Make the entry point script executable
RUN chmod +x /entrypoint.sh

# Set the entry point for the container
ENTRYPOINT ["/entrypoint.sh"]

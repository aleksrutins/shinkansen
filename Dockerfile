FROM ghcr.io/gleam-lang/gleam:v0.32.4-erlang-alpine

# Add project code
COPY . /app/

# Compile the project
RUN cd /app \
  && gleam export erlang-shipment

# Run the server
WORKDIR /app
CMD ["sh", "-c", "sleep 3 && ./build/erlang-shipment/entrypoint.sh run"]
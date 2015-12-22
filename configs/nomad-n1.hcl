log_level = "DEBUG"
bind_addr = "172.20.20.10"

# Setup data dir
data_dir = "/opt/nomad/data"

# Enable the server
server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = 2
    rejoin_after_leave = true
    retry_join = ["172.20.20.11"]
}

client {
    enabled = true
    network_speed = 1000
    network_interface = "enp0s8"
    options = {
        consul.address = "172.20.20.11:8500"
    }
}

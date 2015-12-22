# There can only be a single job definition per file.
# Create a job with ID and Name 'example'
job "hello" {
    # Run the job in the global region, which is the default.
    # region = "global"

    # Specify the datacenters within the region this job can run in.
    datacenters = ["dc1"]

    # Service type jobs optimize for long-lived services. This is
    # the default but we can change to batch for short-lived tasks.
    # type = "service"

    # Priority controls our access to resources and scheduling priority.
    # This can be 1 to 100, inclusively, and defaults to 50.
    # priority = 50

    # Restrict our job to only linux. We can specify multiple
    # constraints as needed.
    constraint {
        attribute = "$attr.kernel.name"
        value = "linux"
    }
    
    meta {
        whoopwhoop = "/job"
    }

    # Configure the job to do rolling updates
    update {
        # Stagger updates every 10 seconds
        stagger = "10s"

        # Update a single task at a time
        max_parallel = 1
    }

    # Create a 'cache' group. Each task in the group will be
    # scheduled onto the same machine.
    group "hello-group" {
        # Control the number of instances of this groups.
        # Defaults to 1
        count = 4

        # Restart Policy - This block defines the restart policy for TaskGroups,
        # the attempts value defines the number of restarts Nomad will do if Tasks
        # in this TaskGroup fails in a rolling window of interval duration
        # The delay value makes Nomad wait for that duration to restart after a Task
        # fails or crashes.
        restart {
            interval = "5m"
            attempts = 10
            delay = "25s"
        }

        meta {
            whoopwhoop = "/group"
        }

        # Define a task to run
        task "say" {
            # Use Docker to run the task.
            driver = "docker"

            meta {
                whoopwhoop = "/say"
            }

            # Configure Docker driver with the image
            config {
                image = "robertshand/python-hello-world:latest"
                port_map {
                    web = 80
                }
            }

            service {
                meta {
                    whoopwhoop = "/service"
                }
                name = "${TASKGROUP}-hello"
                tags = ["global", "cache"]
                port = "web"
                check {
                    name = "alive"
                    type = "http"
                    path = "/"
                    interval = "10s"
                    timeout = "2s"
                }
            }

            # We must specify the resources required for
            # this task to ensure it runs on a machine with
            # enough capacity.
            resources {
                cpu = 50 # 500 Mhz
                memory = 50 # 256MB
                network {
                    mbits = 10
                    port "web" {
                    }
                }
            }
        }
    }
}

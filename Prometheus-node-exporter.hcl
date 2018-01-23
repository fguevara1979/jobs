job "node-exporter" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "node-exporter" {
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "node-exporter-nomad" {
      driver = "docker"

      config {
        image = "prom/node-exporter:latest"
        
        port_map {
          http = 9100
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = 9100
          }
        }
      }

      service {
        name = "node-exporter"

        port = "http"

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/metrics"
        }
      }
    }
  }
}

job "prometheus" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "prometheus" {
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "Prometheus-nomad" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        
        port_map {
          http = 9090
        }

      }

      artifact {
         source      = "https://raw.githubusercontent.com/fguevara1979/jobs/master/prometheus.yml"
         destination = "/etc/prometheus"
        }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = 9090
          }
        }
      }

      service {
        name = "prometheus"

        port = "http"

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/graph"
        }
      }
    }
  }
}

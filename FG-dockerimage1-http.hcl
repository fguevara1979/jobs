job "FG_http_test" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "web" {
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "FG-http-echo" {
      driver = "docker"

      config {
        image = "fguevara1979/linux_tweet_app:2.0"
        
        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = 80
          }
        }
      }

      service {
        name = "http-echo"

        port = "http"

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/"
        }
      }
    }
  }
}

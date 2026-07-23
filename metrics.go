package main

import "github.com/prometheus/client_golang/prometheus"

var (
	httpRequestsTotal = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of HTTP requests received.",
		},
		[]string{"method", "path", "status"},
	)
)
func initMetrics() {
	prometheus.MustRegister(httpRequestsTotal)
}

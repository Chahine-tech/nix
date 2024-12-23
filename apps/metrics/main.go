package main

import (
	"encoding/json"
	"net/http"
	"sync/atomic"

	"github.com/Chahine-tech/nix/pkg/logger"
)

var (
	requestCount uint64
)

func metricsHandler(w http.ResponseWriter, r *http.Request) {
	metrics := map[string]interface{}{
		"total_requests": atomic.LoadUint64(&requestCount),
		"status":         "healthy",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(metrics)

	logger.Info("Metrics accessed", map[string]interface{}{
		"requests": atomic.LoadUint64(&requestCount),
	})
}

func middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		atomic.AddUint64(&requestCount, 1)
		next.ServeHTTP(w, r)
	})
}

func main() {
	logger.Info("Metrics service starting", nil)

	http.Handle("/metrics", middleware(http.HandlerFunc(metricsHandler)))

	logger.Info("Metrics server started on :8081", nil)
	if err := http.ListenAndServe(":8081", nil); err != nil {
		logger.Error("Server failed", err, nil)
	}
}

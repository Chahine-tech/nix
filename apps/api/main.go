package main

import (
	"fmt"
	"net/http"

	"github.com/Chahine-tech/nix/pkg/logger"
)

func handler(w http.ResponseWriter, r *http.Request) {
	logger.Info("Received request", map[string]interface{}{
		"path":   r.URL.Path,
		"method": r.Method,
	})
	fmt.Fprintf(w, "Hello, World!")
}

func main() {
	logger.Info("API service starting", nil)

	http.HandleFunc("/", handler)

	logger.Info("API server started on :8080", nil)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		logger.Error("Server failed", err, nil)
	}
}

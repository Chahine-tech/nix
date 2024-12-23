package main

import (
	"time"

	"github.com/Chahine-tech/nix/pkg/logger"
)

func main() {
	logger.Info("Worker service starting", nil)

	// Example worker loop
	for {
		logger.Info("Processing job", map[string]interface{}{
			"timestamp": time.Now().String(),
		})
		time.Sleep(5 * time.Second)
	}
}

package logger

import (
	"os"

	"github.com/sirupsen/logrus"
)

var log = logrus.New()

func init() {
	log.SetOutput(os.Stdout)
	log.SetFormatter(&logrus.JSONFormatter{})
}

func Info(msg string, fields map[string]interface{}) {
	if fields == nil {
		log.Info(msg)
		return
	}
	log.WithFields(fields).Info(msg)
}

func Error(msg string, err error, fields map[string]interface{}) {
	if fields == nil {
		fields = make(map[string]interface{})
	}
	fields["error"] = err
	log.WithFields(fields).Error(msg)
}

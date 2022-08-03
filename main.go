package main

import (
	"github.com/gin-gonic/gin"
	"os"
	"strconv"
)

func main() {
	var (
		err     error
		rateStr string
		rate    int
		logStr  string
		logFlag bool
	)

	rateStr = os.Getenv("WEB_RATE")
	if len(rateStr) > 0 {
		rate, err = strconv.Atoi(rateStr)
		if err != nil {
			rate = 0
		}
	} else {
		rate = 0
	}

	logStr = os.Getenv("WEB_LOG")
	if len(logStr) > 0 {
		logFlag, _ = strconv.ParseBool(logStr)
	} else {
		logFlag = false
	}

	if logFlag {
		gin.SetMode(gin.DebugMode)
	} else {
		gin.SetMode(gin.ReleaseMode)
	}

	e := gin.New()
	e.Use(gin.Recovery())
	e.Use(ServeStatic())

	if rate > 0 {
		e.Use(RateLimiter(rate))
	}

	if logFlag {
		e.Use(gin.Logger())
	}

	//addrStr := os.Getenv("WEB_ADDR")
	//if len(addrStr) == 0 {
	//	addrStr = "0.0.0.0:8080"
	//}
	//e.Run(addrStr)

	e.Run("0.0.0.0:8080")
}

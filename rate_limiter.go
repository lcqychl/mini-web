package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/time/rate"
)

// 限制每秒钟处理的请求数量
func RateLimiter(maxEventsPerSec int) gin.HandlerFunc {
	limiter := rate.NewLimiter(rate.Limit(maxEventsPerSec), 10)

	return func(c *gin.Context) {
		if limiter.Allow() {
			c.Next()
			return
		}

		c.AbortWithStatus(http.StatusTooManyRequests)
	}
}

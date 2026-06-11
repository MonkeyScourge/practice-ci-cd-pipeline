FROM alpine:latest
RUN apk add --no-cache nginx
RUN mkdir -p /usr/share/nginx/html && \
	echo "<h1>Default page...</h1>" > /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

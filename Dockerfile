FROM golang:latest

WORKDIR /app
COPY go.mod ./ 
COPY go.sum ./
RUN go mod download
COPY *.go ./
RUN go build -o /docker-app
EXPOSE 8080
CMD [ "/docker-app" ]


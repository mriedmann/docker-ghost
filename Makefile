NAME = mriedmann/ghost
VERSION = 0.0.1

all: build

build:
		docker build -t $(NAME) .
		docker build -t $(NAME):$(VERSION) .

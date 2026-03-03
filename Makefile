.PHONY: build config

build:
	docker build -t rclone:latest .

config:
	@mkdir -p config
	docker run --rm -it \
		-v $$(pwd)/config:/config \
		rclone:latest \
		rclone config

.PHONY: setup run test lint build docker-up docker-down clean

setup:
	npm install

run:
	npm start

test:
	npm test

lint:
	npm run lint

build:
	docker-compose build

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

clean:
	docker-compose down
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true

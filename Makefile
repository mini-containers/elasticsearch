build: Dockerfile
	docker build -t mini-elasticsearch .

tag:
	docker tag mini-elasticsearch mini/elasticsearch

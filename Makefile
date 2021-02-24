docker-dev:
	docker build -f Dockerfile.dev -t $(USER)/obs_github_deployments_dev .
	docker run --rm -it -v "$(PWD):/obs_github_deployments" $(USER)/obs_github_deployments_dev bash

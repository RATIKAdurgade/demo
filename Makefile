## make dep: Cache imported packages in vendor directory
build:
	@echo "[ > ] running build"
	@set -x;cd src; bundle install
test:
	@echo "[ > ] running tests"
	@set -x;cd src; rake test

docker-build:
	@echo "[ > ] Building docker image"
	@set -x; pwd; ls -al; cp -a /usr/local/bundle /home/jenkins/agent/workspace/notejam; pwd; ls -al
	@set -x; export TAG=`git rev-parse --short HEAD`;docker build -t 415911685446.dkr.ecr.us-east-1.amazonaws.com/notejam:$$TAG-$$BUILD_ID .
docker-push:
	@echo "[ > ] Pushing docker image"
	@set -x; export TAG=`git rev-parse --short HEAD`;docker push 415911685446.dkr.ecr.us-east-1.amazonaws.com/notejam:$$TAG-$$BUILD_ID
kubernetes-deploy:
	@echo "[ > ] Deploying to kubernetes"
	@set -x; kubectl --kubeconfig $$KUBECONFIG cluster-info
	@set -x; export TAG=`git rev-parse --short HEAD`;cd k8spec;kustomize edit set image notejam=415911685446.dkr.ecr.us-east-1.amazonaws.com/notejam:$$TAG-$$BUILD_ID
	@set -x; cat k8spec/kustomization.yaml
	@set -x; kustomize build k8spec
	@set -x; kustomize build k8spec | kubectl --kubeconfig $$KUBECONFIG  apply  -f -
run:
	@echo "[ > ] Running "
	@set -x; docker run --name notejam --rm -p 8090:3000  notejam:latest 

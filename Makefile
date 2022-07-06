.PHONY: minikube_start
BLUE := $(shell tput setaf 6)
CLEAR := $(shell tput sgr0)

deploy: build_images mount_work deploy_hadoop_namespace deploy_datanode_statefulset deploy_namenode_deployment deploy_resourcemanager_deployment deploy_web_service deploy_spark

clean:
	minikube kubectl -- delete all --all || true
	minikube kubectl -- delete all --all -n hadoop || true
	minikube kubectl -- delete pvc --all -n hadoop || true
	minikube kubectl -- delete configmap --all || true
	minikube kubectl -- delete configmap --all -n hadoop || true
	minikube kubectl -- delete namespace hadoop || true
	rm -rf .deployment

refresh_namenode: build_images deploy_namenode_deployment
	minikube kubectl -- rollout restart deployment/namenode --namespace hadoop

refresh_datanode: build_images deploy_datanode_statefulset
	minikube kubectl -- rollout restart statefulset/datanode --namespace hadoop

refresh_resourcemanager: build_images deploy_resourcemanager_deployment
	minikube kubectl -- rollout restart deployment/resourcemanager --namespace hadoop

refresh_web: deploy_web_service
	minikube kubectl -- rollout restart deployment/web --namespace hadoop

refresh_spark: deploy_spark
	minikube kubectl -- rollout restart deployment/spark --namespace hadoop

deploy_datanode_statefulset:
	@echo "$(BLUE)Deploying Datanodes...$(CLEAR)"
	minikube kubectl -- apply -f manifest/datanode-statefulset.yaml --namespace=hadoop

deploy_namenode_deployment:
	@echo "$(BLUE)Deploying Namenode...$(CLEAR)"
	minikube kubectl -- apply -f manifest/namenode-deployment.yaml --namespace=hadoop

deploy_resourcemanager_deployment:
	@echo "$(BLUE)Deploying ResourceManager...$(CLEAR)"
	minikube kubectl -- apply -f manifest/resourcemanager-deployment.yaml --namespace=hadoop

deploy_web_service:
	@echo "$(BLUE)Deploying Web Service...$(CLEAR)"
	minikube kubectl -- apply -f manifest/web-service.yaml --namespace=hadoop

deploy_spark: mount_work
	@echo "$(BLUE)Deploying Spark...$(CLEAR)"
	minikube kubectl -- apply -f manifest/spark-pod.yaml --namespace=hadoop

rollout_namenode: build_images
	@echo "$(BLUE)Rolling out Namenode...$(CLEAR)"
	minikube kubectl -- rollout restart deployment/namenode --namespace hadoop

rollout_datanode:build_images
	@echo "$(BLUE)Rolling out Datanode...$(CLEAR)"
	minikube kubectl -- rollout restart statefulset/datanode --namespace hadoop

rollout_resourcemanager: build_images
	@echo "$(BLUE)Rolling out ResourceManager...$(CLEAR)"
	minikube kubectl -- rollout restart deployment/resourcemanager --namespace hadoop

rollout_spark: build_images
	@echo "$(BLUE)Rolling out Spark...$(CLEAR)"
	minikube kubectl -- rollout restart pod/spark --namespace hadoop

deploy_hadoop_namespace:
	@echo "$(BLUE)Deploying Namespace...$(CLEAR)"
	minikube kubectl -- apply -f manifest/hadoop-namespace.yaml

build_images: .deployment/minikube_start
	@echo "$(BLUE)Building images...$(CLEAR)"
	cd ./images; ./build.sh
	@echo "$(BLUE)Building images...done$(CLEAR)"

mount_work:
	@echo "$(BLUE)Mounting work directory...$(CLEAR)"
	minikube mount $(shell pwd)/work:/work &
	@echo "$(BLUE)Mounting work directory...done$(CLEAR)"

.deployment/minikube_start: .deployment/check_deps
	mkdir -p .deployment
	@echo "$(BLUE)Starting minikube...$(CLEAR)"
	minikube start --extra-config=apiserver.service-node-port-range=1-65535
	@echo "$(BLUE)Starting minikube...done$(CLEAR)"
	touch .deployment/minikube_start

.deployment/check_deps:
	mkdir -p .deployment
	@echo "$(BLUE)Checking dependencies...$(CLEAR)"
	minikube version
	kubectl version --client=true
	docker --version
	@echo "$(BLUE)Checking dependencies...done$(CLEAR)"
	touch .deployment/check_deps
# Bitbucket CI/CD Pipeline Image with JAVA 11 (JDK)
Included the following packages:

- openjdk-11-jdk
- AWS cli
- Kubernetes
- python3-pip
- NodeJs
- software-properties-common 
- build-essential 
- wget 
- curl 
- git 
- maven 
- ssh-client 
- unzip 
- iputils-ping

This is just an example for **bitbucket-pipelines.yml**
```yaml
options:
  docker: true
pipelines:
  branches:
    master:
      - step:
          name: Production Build on Master
          image: ehsaniara/bitbucket-util:latest
          trigger: automatic
          script:
            - mvn clean install
```

Easy to build your docker during the pipeline:
```yaml
options:
  docker: true
pipelines:
  branches:
    master:
      - step:
          name: Production Build on Master
          image: ehsaniara/bitbucket-util:latest
          trigger: automatic
          script:
            ...
            - docker build -t ${YOUR_PUBLIC_DOCKER_REGISTRY_URL}:$TAG .
            - docker push ${YOUR_PUBLIC_DOCKER_REGISTRY_URL}:$TAG
            - docker tag ${YOUR_PUBLIC_DOCKER_REGISTRY_URL}:$TAG ${YOUR_PUBLIC_DOCKER_REGISTRY_URL}:$TAG
            - docker push ${YOUR_PUBLIC_DOCKER_REGISTRY_URL}:$TAG
           ...
```

Easy to run your CI/CD pipeline with Kubernetes:
```yaml
options:
  docker: true
pipelines:
  branches:
    master:
      - step:
          name: Production Build on Master
          image: ehsaniara/bitbucket-util:latest
          trigger: automatic
          script:
            ...
            - kubectl config set-cluster ${KUBERNETES_PROVIDER_CLUSTER_NAME} --server=${KUBERNETES_PROVIDER_SERVER} --certificate-authority="$(pwd)/kube_ca"
            - kubectl config set-credentials bitbucket --token="$(cat ./kube_token)"
            - kubectl config set-context development --cluster=${KUBERNETES_PROVIDER_CLUSTER_NAME} --user=bitbucket # I assume you have already setup your K8s ServiceAccount
            - kubectl config use-context development
            ...
```

# Istio Getting Started Demo / Lab

## Requirements

* git / github access
* [docker](https://www.docker.com/products/docker-desktop)
* [minikube](https://minikube.sigs.k8s.io/docs/start/)
* internet connectivity to fetch images (large)
* lots of memory (8GB min)

## Objectives

* Test local system
* Discover a new systems topology
* Debug a new system

## Getting Started

Remove any previous cluster and start a cluster
`minikube delete`
`minikube start --memory 4096`

Setup the environment and spin up Istio

1. `k apply -f 1-init.yaml`
1. `k apply -f 2-istio.yaml`

Confirm istio is up and running  `k get pod -A -w`

**note:** get familar with env
`k get svc -n istio-system`

Spin up apps

1. `k apply -f 3-app.yaml`

```bash
❯ k get po
NAME                                  READY   STATUS              RESTARTS   AGE
api-gateway-ccff6b96d-6ck28           0/1     ContainerCreating   0          7s
photo-service-7d458595bf-jpxk8        0/1     ContainerCreating   0          7s
position-simulator-869d6489cb-6w84d   0/1     ContainerCreating   0          7s
position-tracker-6f7886d758-2kd8l     0/1     ContainerCreating   0          7s
staff-service-6cb6947d47-6hmfp        0/1     ContainerCreating   0          7s
vehicle-telemetry-587f74c988-4lrhn    0/1     ContainerCreating   0          7s
webapp-6c9c9c659f-ppxmm               0/1     ContainerCreating   0          7s
```

Tear it down

1. `k delete -f 3-app.yaml`

Setup istio for namespace

1. `k label ns default istio-injection=enabled`

And launch the apps again... what is different?

Looking at the App and Services

* app `minikube service fleetman-webapp --url`
* kiali `minikube service kiali --url -n istio-system`
* jaeger `minikube service tracing --url -n istio-system`

**NOTE:**
There is an issue with the application... you are a new hire and need to help understand where the team should focus their attention.

* kiali should pin point the issue
* jaeger will help if you have some system awareness

### Demo

* lets disable the service and see changes in jaeger and kaili

**References**

* minikube ip
* minikube service {service-name} --url -n istio-system
* k get svc {-n istio-system}

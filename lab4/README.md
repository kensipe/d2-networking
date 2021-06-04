# Gateway labs

Adding a Istio Gateway for inbound load balancing and routing control.
Previous Routing was service to service.  In this case we want the in-bound requests to be routed.

Deploy all the things (1-3) prefixed files.  If starting from previous lab, delete all deploys in the default namespace, before applying 3-app.yaml.

start the tunnel and confirm everything is running!
`minikube service fleetman-webapp --url`

Once we have everything is confirmed running... lets continue with the lab

## Adding an new UI

Find the Deployment for `webapp` and add a label for version, making it version v1.
Make a copy of the deployment and create another deployment named `webapp-2` changing the version labels to `v2`.  Change the image to the new image: `kensipe/fleetman-webapp-angular:v2`

* Deploy the apps with the new webapp-2
* Refresh the web view, you should see the old UI and the new UI with a banner alternating

**note:** you can also update the `curl-check.sh` to see the freq of one version of the UI vs. the other UI version

* Adjust 90% traffic to v1 and test

**question:** Is the weighted values working?

## Adding a Gateway

Prior to this point, the load-balancing was handled by kubernetes.  We will need an edge proxy in order to handle inbound requests.  Istio has this ability via the istio gateway (specifically an istio ingress gateway).

run the following:

* `k get pod -n istio-system | grep gateway`
* `k get svc -n istio-system | grep gateway`

```bash
❯ k get svc -n istio-system | grep gateway
istio-egressgateway    ClusterIP      10.98.53.195     <none>        80/TCP,443/TCP,15443/TCP                                                     5h44m
istio-ingressgateway   LoadBalancer   10.97.99.15      <pending>     15021:32000/TCP,80:31380/TCP,443:32002/TCP,31400:32003/TCP,15443:32004/TCP   5h44m
```

**note:** what is the service type?

`minikube service istio-ingressgateway -n istio-system --url`

Connect to istio gateway:  `minikube service istio-ingressgateway -n istio-system --url`
What is the error?

Apply the istio gateway configuration in 5-gateway.yaml

`k apply -f 5-gateway.yaml`
Reconnect to istio gateway.  What is the error now?

We need to configure the gateway to connect to the virtual service!  Pull the virtual service (from kiali, or kubernetes or in `ref-vs-dr.yaml` file) and add a gateway to the spec of the virtual service.

Add the following to the virutal service:

```yaml
spec:
  gateways:
    - ingress-gateway-configuration
  hosts:
    - "*"
```

* check the web from the ingress url
* update the curl-check.sh to the ingress port and check the weighted routing

## Dark Releases

Examine `6-dark.yaml` file.  Its a change from the previous virtual service which includes a header match.  If applied, the v1 of the UI will always be displayed for standard headers.  Test this.

* Change the port of `6-dark.yaml` file to the working istio gateway service port and run with and with out `v2` for the header request.

```bash
❯ ./dark-release-test.sh
  <title>Fleet Management</title>
❯ ./dark-release-test.sh
  <title>Fleet Management</title>
❯ ./dark-release-test.sh
  <title>Fleet Management</title>
```

and

```bash
❯ ./dark-release-test.sh v2
  <title>Fleet Management Istio Premium Enterprise Edition</title>
❯ ./dark-release-test.sh v2
  <title>Fleet Management Istio Premium Enterprise Edition</title>
❯ ./dark-release-test.sh v2
  <title>Fleet Management Istio Premium Enterprise Edition</title>
```

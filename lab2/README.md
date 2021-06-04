# Telemetry Labs

## Objectives

* Deep dive into Kiali, Jaeger, Grafana
* Disabling Traffic
* HTTP Header Prop
* Spanning Traffic

## Starting with Lab1

Starting with the previous lab, lets take a deeper dive into each of the telemetry tools.

## Kiali

Review the following in the Kiali UI

* Overview
* Graph and Graph Settings
* Time Window
* Legend
* Req/Sec + Animation
* gray traffic / green traffic / absence of traffic

Perform the following action

* disable fleetman-staff-service

From the command line: `k get vs`.  Kiali generates Istio specific Resources.

* view from kiali

## Restart with Non-Broken App

Either delete resources for apps in lab1  (init and istio are same) or start over by:

`minikube delete`
`minikube start --memory 4096`

and apply files starting with 1 and 3 **note:** make sure you apply `3-app.yaml`

## Tracing / Jaeger

* View Jaeger
`minikube service tracing --url -n istio-system`
* Traces and Spans
* HTTP Header Propagation

**note:** Spans are full trace

### Add http header propagation apps

The 4-app.yaml contains the same services with http header propagation capabilities added.  Here are a few reference links:

* [Istio FAQ #distributed-tracing](https://istio.io/latest/about/faq/#distributed-tracing)
* [zipkin b3-propagation](https://github.com/openzipkin/b3-propagation)

Example Interceptor:

```java
@Component
public class PropagateHeadersInterceptor implements RequestInterceptor {

	private @Autowired HttpServletRequest request;

	public void apply(RequestTemplate template) {
		try
		{
			Enumeration<String> e = request.getHeaderNames();
			while (e.hasMoreElements())
			{
				String header = e.nextElement();
				if (header.startsWith("x-"))
				{
					String value = request.getHeader(header);
					template.header(header, value);
				}
			}
		}
		catch (IllegalStateException e) {}
	}
}
```

`k delete -f 3-app.yaml`
`k apply -f 4-app.yaml`

* Revisit Jaeger
What is the id that ties it all together?

* Select Time Window

## Grafana

`minikube service grafana --url -n istio-system`

Evaluate the following:

* non-500 errors
* control plane metrics
* data plane metrics
* Istio mesh dashboard

# Circuit Breaker

### Resources

https://en.wikipedia.org/wiki/Cascading_failure
https://sre.google/sre-book/addressing-cascading-failures/
https://istio.io/latest/docs/tasks/traffic-management/circuit-breaking/

## Lab

From a fresh cluster, apply files prefixed (1-4)

Review the web UI: `minikube service fleetman-webapp --url`
Clicking on several vehicles and notice the difference...  the fleet-service (staff images) alternates between good and bad experiences.  The bad experiences includes delays and error 5xx.

**note:** Use the curl check with `./curl-loop.sh 50679` using your port

```
❯ ./curl-loop.sh 50679
{"name":"Pam Parry","photo":"https://rac-istio-course-images.s3.amazonaws.com/1.jpg"}
{"timestamp":"2021-06-04T03:04:58.429+0000","status":500,"error":"Internal Server Error","message":"status 502 reading RemoteStaffMicroserviceCalls#getDriverFor(String)","path":"//vehicles/driver/City%20Truck"}
{"name":"Pam Parry","photo":"https://rac-istio-course-images.s3.amazonaws.com/1.jpg"}
{"timestamp":"2021-06-04T03:05:03.196+0000","status":500,"error":"Internal Server Error","message":"status 502 reading RemoteStaffMicroserviceCalls#getDriverFor(String)","path":"//vehicles/driver/City%20Truck"}
{"name":"Pam Parry","photo":"https://rac-istio-course-images.s3.amazonaws.com/1.jpg"}
```

Apply the circuit breaker:  `k apply -f 5-circuit-breaking.yaml`

Click through the UI again... If you can get 2 HTTP 5xx errors in 10s... what happens?
**notes:** The quick way is to use the curl script!
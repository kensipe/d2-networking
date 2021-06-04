# Fault Injection

[Istio documentation on Fault Injection](https://istio.io/latest/docs/tasks/traffic-management/fault-injection/)

Using previous lab, create a virtual service for the fleet-vehicle-telemetry which suspends traffic.

IF you used Kiali to create it, modify the yaml to fail 50% of the time.

Observe the UI running with and without the failure.  What is different?

There are 2 types of faults that are possible:

* Abort
* Delay

Add a 7s delay on the fleetman-staff-service, and observe the affects on the UI.

BONUS:
Change the header to the gateway from "my-header" to "x-my-header".  Update the delay image to only occur for an x-my-header=v2.

```yaml
spec:
  hosts:
    - fleetman-staff-service
  http:
    - match:
        - headers:
            x-my-header:
              exact: v2
      fault:
        delay:
          percentage:
            value: 100.0
          fixedDelay: 7s
      route:
        - destination:
            host: fleetman-staff-service
            subset: v2
```

**Note:** We can use dark release feature to inject faults

## Namespace/Pod/Service/Deployment Configurations for HAProxy ingress controller

To deploy to a kubernetes cluster, use one of the following 2 methods:

## A.
0. Install helm
1. Add haproxy repo:
    ```bash
    helm repo add haproxytech https://haproxytech.github.io/helm-charts
    ```
2. Install the haproxy controller
    ```bash
    helm install haproxy-controller haproxytech/kubernetes-ingress
    ```

## B.
0. Apply the haproxy configuration one of two ways:
    i) With the config from the haproxy repo:
        ```bash
        kubectl apply -f https://raw.githubusercontent.com/haproxytech/kubernetes-ingress/master/deploy/haproxy-ingress.yaml
        ```
    ii) With the config in this directory:
        ```bash
        kubectl apply -f ./haproxy-ingress.yaml
        ```


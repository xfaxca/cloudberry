## Kubernetes Dashboard

Instructions can be found at https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/. However, some steps are not very clear and/or do not specify how to access the dashboard outside of the host machine, so some suggestions are listed here.

1. Install/Run/Deploy the dashboard
    - e.g., `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml`

2. Modify deployment port configuration from default ClusterIp to NodePort
    - Edit via (assuming kubernetes-dashboard namespace is used): `kubectl -n kubernetes-dashboard edit service kubernetes-dashboard`  
    - Change `spec.type` to `NodePort`

3. Create a user (sample admin shown here)
    - https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
    - (`create_admin_user.yaml` also available for quicker configuration)
    - Get token (here, for user admin-user): `kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')`
    - Save the token for use later when logging into the dashboard.

4. Generate a self-signed SSL certificate
    - See `cloudberry/scripts/ssl/create_self_signed_cert.sh`
    - Link: https://github.com/kubernetes/dashboard/blob/master/docs/user/certificate-management.md

5. Create kubernetes secret and edit deployment to use the generated certificates (here, assuming `tls.crt`/`tls.key` in $HOME/certs
    - kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kubernetes-dashboard
    - kubectl -n kubernetes-dashboard edit deployment kubernetes-dashboard
    - In the yaml config that displays after the above command, add tls arguments to the pod definitions:
    ```yaml
    containers:
      - args:
        - --tls-cert-file=/tls.crt
        - --tls-key-file=/tls.key
    ```
    - You can leave the option `--auto-generate-certificates` in place and it will be used as backup. However, that method does not work in some situations, dending on the configuration of your cluster.

6. Get the node port for the kubernetes dashboard
    - `kubectl get svc -o wide -n kubernetes-dashboard`
    - You will see something like the following, where 32113 is the https node port for the dashboard:
    ```bash
    NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE   SELECTOR
    dashboard-metrics-scraper   ClusterIP   xx.xx.xxx.xx    <none>        8000/TCP        72m   k8s-app=dashboard-metrics-scraper
    kubernetes-dashboard        NodePort    xx.xx.xx.xxx   <none>        443:32113/TCP   72m   k8s-app=kubernetes-dashboard
    ```bash

7. Access the dashboard via the nodeport and use the token from step 3 to log in.

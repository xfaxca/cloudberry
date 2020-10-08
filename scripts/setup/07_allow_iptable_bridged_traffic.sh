# According to the documentation, Kubernetes needs iptables to be configured to see bridged network traffic to ensure that 
# Kubernetes cluster addresses go via the appropriate adapter if Kube components are not reachable on the default route. 
# Doc link: https://v1-18.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic
# The following command does this:
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

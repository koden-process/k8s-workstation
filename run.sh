kubectl apply -f pod.yaml
kubectl apply -f service.yaml

kubectl get svc ubuntu-pod-service
kubectl get nodes -o wide

echo 'ssh -p xxxxx root@<node-ip> (xxxxx is the port number of the node, <node-ip> is the IP address of the node)'
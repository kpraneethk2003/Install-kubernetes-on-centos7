# centos7
### Note: Run these files as a root user
## On Master Node:
1. clone this repository and make files executable
2. Make master.sh executable : `chmod +x master.sh`
3. Run master.sh : `./master.sh`
4. make a note of the command that is printed(used to join worker nodes to cluster)
5. run the following 3 commands as **normal** user
- mkdir -p $HOME/.kube
- sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
- sudo chown $(id -u):$(id -g) $HOME/.kube/config
6. As a root user, Run: `export KUBECONFIG=/etc/kubernetes/admin.conf`
7. Now on your master node, setup calico
8. Make calico.sh executable `chmod +x calico.sh`
9. Run `./calico.sh`
10. Wait until all nodes are ready and after that run `kubectl taint nodes --all node-role.kubernetes.io/control-plane-`
* after successful execution on master node, use the command that is printed to join worker nodes.
## On Worker Node: 
1. Now for worker nodes, on every node make worker.sh executable `chmod +x worker.sh`
2. Run worker.sh: `./worker.sh`
3. Now worker node is also ready. Join it to the cluster using the command that you previously made a note.
4. Or run: `kubeadm token create --print-join-command`

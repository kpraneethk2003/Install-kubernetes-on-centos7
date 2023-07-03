# centos7
##Note: 
Run these files as a **root** user
clone this repository and make files executable
command: "chmod +x filename"
command to run "./master.sh"
make a note of the command that is printed(used to join worker nodes to cluster)
run the following 3 commands as normal user
1.mkdir -p $HOME/.kube
2.sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
3.sudo chown $(id -u):$(id -g) $HOME/.kube/config
As a root user,run this command "export KUBECONFIG=/etc/kubernetes/admin.conf"
now on your master node, setup calico
make calico.sh executable "chmod +x calico.sh"
run "./calico.sh"
wait until all nodes are ready and after that run "kubectl taint nodes --all node-role.kubernetes.io/control-plane-"
after successful execution on master node, use the command that is printed to join worker nodes.
now for worker nodes, make worker.sh executable "chmod +x worker.sh"
run it "./worker.sh"
now worker node is also ready join it to the cluster using the command that you previously made a note.

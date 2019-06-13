
label=$1
attribute=$2

tmux start-server
pods_name=(`kubectl get pods -l=$1=$2 | grep api | awk '{print $1}'`)

cmd="kubectl exec -it ${pods_name[0]} bash"
tmux new-session -d -s "kube-texec_$1-$2" "$cmd"

pods_name=("${pods_name[@]:1}")
for pod_name in ${pods_name[@]}; do
	cmd="kubectl exec -it $pod_name bash"
	tmux split-window  -t "kube-texec_$1-$2" "$cmd"
	tmux select-layout -t "kube-texec_$1-$2" tiled 1>/dev/null
done

tmux set-window-option -t "kube-texec_$1-$2" synchronize-panes on
tmux select-pane -t 0
tmux attach-session -t "kube-texec_$1-$2"

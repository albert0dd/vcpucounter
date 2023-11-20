#!/bin/bash

total_cpus=0
vm_info=$(kubectl get virtualmachine -A -o custom-columns=NAME:.metadata.name,VMCLASS:.spec.className,NS:.metadata.namespace --no-headers)

while IFS= read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    vmclass=$(echo "$line" | awk '{print $2}')
    namespace=$(echo "$line" | awk '{print $3}')
    cpu=$(kubectl get virtualmachineclass "$vmclass" -n "$namespace" -o json | jq -r '.spec.hardware.cpus')
    total_cpus=$((total_cpus + cpu))
done <<< "$vm_info"

control_plane_cpus=$(kubectl get nodes -l node-role.kubernetes.io/control-plane= --no-headers -o custom-columns=CPUS:.status.capacity.cpu | awk '{sum+=$1} END {print sum}')
total_cpus=$((total_cpus + control_plane_cpus))
echo "$total_cpus@$control_plane_cpus" // Separando los valores con @


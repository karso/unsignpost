#!/bin/bash

###################################################################
#Script Name	: script.sh
#Description	: Deploys applications in 'minikube' based k8s
#Args           : None
#Author       	: Soumitra Kar
#Email         	: ranaghoul@gmail.com
#Version	: 0.2.0
###################################################################

usage() {
  printf "Usage: $0\n"
}

while getopts ":h" option; do
  case $option in
    h)
         usage
         exit 0
  esac
done


minikube_status() {
  # Check installation
  mk=`which minikube`
  if [ "$mk" == "" ]; then
    printf "Minikube installation not found.\n"
    printf "Please fix the problem and try again.\n"
    exit 1
  fi

  # Check if running and configured correctly
  # mk_run=0 # `minikube status | grep -v 'Running\|Correctly Configured' | wc -l`
  mk_run=`minikube status | grep ':' | grep -v 'minikube\|Running\|Configured\|Control Plane\|Nonexistent' | wc -l`
  if [ $mk_run -ne 0 ]; then
    printf "Minikube not running as expected.\n"
    printf "\n************\n"
    minikube status
    printf "************\n\n"
    printf "Please fix the problem and try again.\n"
    exit 1
  else
    printf "minikube is working fine. Moving on to the next step...\n\n"
  fi
}

kubernetes_status() {
  k8s_pods=`kubectl get pods -n kube-system | grep -v "Running\|NAME" | wc -l`
  if [ $k8s_pods -ne 0 ]; then
    printf "Kubernetes cluster is not running as expected.\n"
    printf "\n************\n"
    kubectl get pods -n kube-system
    printf "************\n\n"
    printf "Please fix the problem and try again.\n"
    exit 1
  else
   printf "Kubernetes cluster is working fine. Moving on to the next step...\n\n"
  fi
}

build_image() {
  application=$1
  docker build -t $application $application/docker/. &>/dev/null
  if [ $? -ne 0 ]; then
    printf "  The application $application image could not be built\n"
    printf "  COMMAND: docker build -t $application $application/docker/.\n"
    printf "  \n************\n"
    docker build -t $application $application/docker/.
    printf "  ************\n\n"
    printf "  Please fix the problem and try again.\n"
    exit 1
  else
    printf "  The $application image is successfully built. Moving on to the next step...\n\n"
  fi
}

deploy(){
  application=$1
  content=`ls $application/manifests/*.yaml`
  count=`echo $content | grep 'No such file or directory' | wc -l`
  if [ $count -eq 1 ]; then
    printf "No manifest file found in $application/manifests directory"
    printf "Skipping the $application deployment"
  else
    for mfile in $(echo $content); do
      printf "  Creating $mfile...\n"
      kubectl create -f $mfile
      printf "\n"
    done
  fi
}

# Check minikube status
minikube_status

# Check k8s status (Doing this for the coredns issue I faced)
kubernetes_status

# Create the application images
printf "Building the necessary images...\n"
for app_dir in $(ls -d */ | cut -f1 -d'/'); do
  build_image $app_dir
done

# Create a namespace and deploy the applications
ns_exists=`kubectl get namespaces | grep signavio | wc -l`
if [ $ns_exists -eq 0 ]; then
  kubectl create namespace signavio
  if [ $? -eq 0 ]; then
    printf "A namespace \'signavio\' is created\n\n"
  else
    printf "A namespace could not be created.\n"
    printf "COMMAND: kubectl create namespace signavio\n"
    printf "Please fix the problem and try again."
    exit 1
  fi
else
  printf "A namespace \'signavio\' already exists. Moving on to the next step...\n\n"
fi

printf "Deploying the applications...\n"
for app_dir in $(ls -d */ | cut -f1 -d'/'); do
  deploy $app_dir
  printf "Application $app_dir deployed\n"
  printf "\n\n"
done

# Get the service URL
printf "Use the below URL to verify the solution\n"
minikube service --url consumer -n signavio
printf "\nDeployment is complete\n"
printf "\n********************\n"

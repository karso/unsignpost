## script.sh v 0.2.0

#### Assumptions
  - Tested on minikube version 1.17.0
  - Tested on kubernetes version 1.18.1
  - Applications using python version 3.5
  
#### Fixes
  - **WantUpdateNotification** 
  
#### Open Issues
  - **DNS Loop** : Sometimes the above mentioned version of the minikube fails to start the coredns component properly inside a VM due to a DNS loop in resolve config. Check [this link](https://stackoverflow.com/questions/53075796/coredns-pods-have-crashloopbackoff-or-error-state) for more details.
  - **Backward Compatibility** : This version does not work with older version of kubernetes. 

## script.sh v (init)
#### Assumptions
  - No restriction on used software and versions

#### Requirements
  - A running minikube environment (Tested on minikube version 1.0.1 running in a VM) 
  - A properly configured kubernetes cluster. (Tested on version 1.14. I have seen a coredns issue. For more details see 'Issues')

#### Execution
  - Run the following commands

    ``` $ cd coding-challenge-soumitra-kar ```

    ``` $ chmod 755 script.sh ```

    ``` $ ./script.sh ```

  - At the end of the deployment you'll get a link to verify the solution.



#### Issues
  - **DNS Loop** : Sometimes the above mentioned version of the minikube fails to start the coredns component properly inside a VM due to a DNS loop in resolve config. Check [this link](https://stackoverflow.com/questions/53075796/coredns-pods-have-crashloopbackoff-or-error-state) for more details. 
  - **WantUpdateNotification** : This message pops up once in a while for an old version of minikube breaking the deployment logic at times. Difficult to reproduce.

#### To Do
  - **Log** : I could have made it part of the script; and for a serious env (read prod) I should. However, minikube is more dev and all the action is logged on to terminal so it can be deferred for now.
  -  **Note to self**: Upgrade minikube, kubernetes and python version. That will likely fix both the issues mentioned above. 




## Prerequisites

* A Kubernetes cluster
* A user shaozhen with [Authentication](https://kubernetes.io/docs/admin/authentication) but no [Authorization](https://kubernetes.io/docs/admin/authorization/) assigned
* The cluster has [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/) authorization mode enabled

## Create namespace with **admin**

```
kubectl create -f namespace.yml
```

## List pods with **shaozhen** failed

The operation should failed due to authorization failure

```
kubectl get pods -n demo-authz
Error from server (Forbidden): pods is forbidden: User "shaozhen" cannot list pods in the namespace "demo-authz"
```

## Create Pod Reader Role and Role binding with **admin**

* Create Pod Reader role in demo-authz namespace

  ```
  kind: Role
  apiVersion: rbac.authorization.k8s.io/v1
  metadata:
    namespace: demo-authz
    name: pod-reader
  rules:
  - apiGroups: [""] # "" indicates the core API group
    resources: ["pods"]
    verbs: ["get", "watch", "list"]
  ```

  ```
  kubectl create -f pod-reader.yml
  ```

* Create role binding to bind **shaozhen** to the reader role

  ```
  kind: RoleBinding
  apiVersion: rbac.authorization.k8s.io/v1
  metadata:
    name: read-pods
    namespace: demo-authz
  subjects:
  - kind: User
    name: shaozhen
    apiGroup: rbac.authorization.k8s.io
  roleRef:
    kind: Role
    name: pod-reader
    apiGroup: rbac.authorization.k8s.io  
  ```

  ```
  kubectl create -f role-binding-pod-reader.yml
  ```

* List pods by using **shaozhen** successfully

  ```
  kubectl get pods -n demo-authz
No resources found.
  ```

## Create deployments with **shaozhen** failed

  ```
  kubectl create -f music.yml
Error from server (Forbidden): error when creating "music.yml": deployments.extensions is forbidden: User "shaozhen" cannot create deployments.extensions in the namespace "demo-authz"
  ```

## Add deployment role and bind **shaozhen** to the role

  ```
  kubectl create -f deployment-extensions.yml
  kubectl create -f role-binding-deployment.yml
  ```

  Now, **shaozhen** should be able to do the deployment
  ```
  kubectl create -f music.yml
  kubectl get pods -n demo-authz
NAME                          READY     STATUS        RESTARTS   AGE
test-music-69d47f9bc5-542pl   1/1       Running       0          23s
  ```

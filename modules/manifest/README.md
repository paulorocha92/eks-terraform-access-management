# Definir permissão ao cluster

O módulo `manifest` contém definições que são aplicadas no cluster Kubernetes por meio do arquivo `rbac.yaml`. Ele utiliza o Terraform para executar a aplicação desses recursos no Kubernetes.

Neste arquivo `manifest.tf`, é definido um recurso do tipo null_resource que utiliza um provisionador local (local-exec) do Terraform. Esse provisionador executa um comando kubectl apply para aplicar as definições do arquivo rbac.yaml no cluster Kubernetes.

O arquivo `rbac.yaml` contém definições de Roles e RoleBindings (ClusterRoles e ClusterRoleBindings) para o controle de acesso baseado em funções (RBAC - Role-Based Access Control) no Kubernetes. Ele cria permissões e associações de permissões a grupos de usuários ou serviços.

As definições no rbac.yaml criam três ClusterRoles (eks-admin, eks-developer, eks-qa) e associam essas Roles a diferentes permissões e grupos.

- eks-admin: tem permissões para todas as APIs e recursos (*) dentro do cluster.
- eks-developer: tem permissões específicas para manipular Pods, Serviços e Deployments, e visualizar ConfigMaps.
- eks-qa: tem permissões limitadas para visualizar e listar Deployments, ConfigMaps, Pods, Secrets e Services.

Cada ClusterRole tem um ClusterRoleBinding correspondente, associando-o a um grupo específico para conceder as permissões definidas.
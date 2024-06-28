# Automatização e Gestão do Amazon EKS: Infraestrutura Escalável e Gerenciável

Este projeto visa a gestão de acessos de ambientes Kubernetes no Amazon EKS usando o Terraform. Utilizamos Terraform para criar e configurar grupos de usuários, associá-los a roles e role bindings dentro do EKS, proporcionando uma política de acesso para os clusters Amazon EKS.

## Permissões Concedidas

O módulo concede as seguintes permissões:

- Permissão para executar operações EKS, utilizando ações como `eks:*`, fornecendo acesso necessário aos recursos EKS.
- Permissão para assumir a role criada, permitindo que os usuários identificados possam interagir com o cluster EKS.

## Detalhes Técnicos

O módulo cria políticas IAM personalizadas e roles específicas para entidades designadas, garantindo que somente os usuários ou entidades autorizadas possam interagir com o Amazon EKS.

### Módulo eks-roles

O módulo `eks-roles` é responsável por criar os grupos de usuários na AWS. Esses grupos serão utilizados para organizar os usuários com base nos níveis de acesso definidos: admin, qa e developer.

Os nomes dos grupos serão criados na AWS da seguinte maneira:

- `admin-${var.cluster_name}-eks-access-group`
- `qa-${var.cluster_name}-eks-access-group`
- `developer-${var.cluster_name}-eks-access-group`

Para visualizar o que está sendo criado, veja o diretório `modules/eks-roles`:

- `group.tf`: Definição de grupos e permissões relacionadas ao Amazon EKS.
- `locals.tf`: Declaração de variáveis locais para o módulo.
- `main.tf`: Configurações principais do módulo.
- `variables.tf`: Declaração de variáveis utilizadas no módulo.

### Módulo manifest

O módulo `manifest` é responsável por criar as `ClusterRole` e `ClusterRoleBinding` no Kubernetes, definindo os níveis de acesso para os grupos admin, qa e developer. Esses recursos garantem que cada grupo tenha as permissões de forma separada dentro do cluster Kubernetes.

Arquivos importantes:

- `rbac.yaml`: Arquivo de manifesto para definição de controle de acesso baseado em funções (RBAC).
- `manifest.tf`: Executa o `rbac.yaml`.

## Passos para Iniciar e Aplicar o Terraform

### Inicialização

Navegue até a pasta `dev` dentro do diretório `environment`:

```bash
cd environment/dev
```

Inicialize o Terraform:

```bash
terraform init
```

### Aplicação

Revise os arquivos de configuração (modules.tf, provider.tf, variables.tf) para garantir que as variáveis estejam corretas para o seu ambiente.

Verifique o plano de execução para ver as mudanças que serão aplicadas:

```bash
terraform plan
```

Aplique as mudanças:

```bash
terraform apply
```

### Alterar o aws-auth ConfigMap

Depois de aplicar o Terraform, é necessário um passo manual para modificar o aws-auth ConfigMap no Kubernetes, garantindo que os novos grupos e permissões sejam corretamente aplicados no EKS.


```bash

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::<ACCOUNT_AWS>:role/admin-<NOME DO CLUSTER>
      username: admin-<NOME DO CLUSTER>
      groups:
      - eks-admin
    - rolearn: arn:aws:iam::<ACCOUNT_AWS>:role/developer-<NOME DO CLUSTER>
      username: developer-<NOME DO CLUSTER>
      groups:
      - eks-developer
    - rolearn: arn:aws:iam::<ACCOUNT_AWS>:role/qa-<NOME DO CLUSTER>
      username: qa-<NOME DO CLUSTER>
      groups:
      - eks-qa
    # Inclua aqui outras roles já existentes para não perder nenhuma configuração

```

## Conclusão

Este projeto utiliza Terraform para provisionar e gerenciar acessos no AWS EKS de forma eficiente e escalável. A abordagem descrita garante que os grupos de usuários e suas permissões sejam configurados corretamente, integrando-se com os módulos existentes e permitindo uma gestão centralizada dos recursos.
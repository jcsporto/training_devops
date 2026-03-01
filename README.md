# 🚀 DevOps Training - Terraform Infrastructure as Code

Projeto de estudos focado em Infrastructure as Code (IaC) utilizando Terraform para provisionamento de recursos na AWS.

## 📋 Sobre o Projeto

Este repositório demonstra conhecimentos práticos em:
- **Terraform**: Provisionamento de infraestrutura declarativa
- **AWS**: Gerenciamento de recursos cloud (S3, VPC, IAM)
- **Git/GitHub**: Versionamento de código com boas práticas de segurança
- **DevOps**: Automação e gerenciamento de infraestrutura

## 🏗️ Estrutura do Projeto

```
devops-training/
├── backend/              # Configuração de backend remoto (S3)
│   ├── main.tf          # Provider AWS e configurações
│   ├── variables.tf     # Definição de variáveis
│   └── s3.bucket.tf     # Bucket S3 para remote state
│
├── networking/          # Recursos de rede
│   ├── main.tf         # VPC e configurações de rede
│   └── variables.tf    # Variáveis de rede
│
└── terraform.tfvars.example  # Template de variáveis
```

## 🔧 Recursos Provisionados

### Backend Module
- **S3 Bucket**: Armazenamento de Terraform state com versionamento habilitado
- **IAM Role**: Assume role com external ID para segurança adicional

### Networking Module
- **VPC**: Virtual Private Cloud com CIDR 10.0.0.0/16
- **Remote State**: Backend S3 configurado para state compartilhado

## 🚀 Como Usar

### Pré-requisitos
- Terraform >= 1.9
- AWS CLI configurado
- Credenciais AWS com permissões adequadas

### Configuração Inicial

1. Clone o repositório:
```bash
git clone <seu-repositorio>
cd devops-training
```

2. Configure suas credenciais:
```bash
# Copie o template
cp terraform.tfvars.example terraform.tfvars

# Edite com suas credenciais (este arquivo NÃO será commitado)
vim terraform.tfvars
```

3. Configure o AWS profile:
```bash
aws configure --profile training_devops
```

### Executando o Terraform

```bash
# Backend - Criar bucket para remote state
cd backend/
terraform init
terraform plan
terraform apply

# Networking - Provisionar VPC
cd ../networking/
terraform init
terraform plan
terraform apply
```

## 🔒 Segurança

Este projeto implementa as seguintes práticas de segurança:

✅ **Separação de credenciais**: Valores sensíveis em `terraform.tfvars` (não versionado)  
✅ **GitIgnore robusto**: Proteção contra commit acidental de secrets  
✅ **IAM Assume Role**: Uso de roles com external ID  
✅ **Remote State**: State armazenado em S3 com versionamento  
✅ **No hardcoded secrets**: Todas as credenciais via variáveis

### Arquivos Protegidos (não versionados)
- `*.tfvars` - Credenciais e valores sensíveis
- `*.tfstate` - Estado da infraestrutura
- `.terraform/` - Dependências e cache

## 📚 Conceitos Aplicados

- **Infrastructure as Code (IaC)**: Infraestrutura versionada e reproduzível
- **Remote State**: Compartilhamento seguro do state entre equipes
- **Modularização**: Separação lógica de recursos (backend/networking)
- **Variables**: Parametrização para diferentes ambientes
- **Security Best Practices**: Proteção de credenciais e secrets

## 🎯 Objetivos de Aprendizado

- [x] Configurar provider AWS com assume role
- [x] Criar e gerenciar remote state em S3
- [x] Provisionar recursos de rede (VPC)
- [x] Implementar segurança no versionamento de código
- [x] Estruturar projeto Terraform modular
- [ ] Adicionar módulos de compute (EC2, ECS)
- [ ] Implementar CI/CD com GitHub Actions
- [ ] Adicionar testes de infraestrutura (Terratest)

## 📖 Referências

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

---

💡 **Projeto desenvolvido para fins de estudo e demonstração de habilidades em DevOps/Cloud**

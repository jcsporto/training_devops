# 🚀 DevOps Training - Terraform Infrastructure as Code

Projeto de estudos focado em Infrastructure as Code (IaC) utilizando Terraform para provisionamento de recursos na AWS.

## 📋 Sobre o Projeto

Este repositório demonstra conhecimentos práticos em:
- **Terraform**: Provisionamento de infraestrutura declarativa
- **AWS**: Gerenciamento de recursos cloud (VPC, Subnets, NAT Gateway, S3, IAM)
- **Git/GitHub**: Versionamento de código com boas práticas de segurança
- **DevOps**: Automação e gerenciamento de infraestrutura
- **Bash Scripting**: Validação e automação de configurações

## 🏗️ Estrutura do Projeto

```
devops-training/
├── backend/                    # Configuração de backend remoto (S3)
│   ├── main.tf                # Provider AWS e configurações
│   ├── variables.tf           # Definição de variáveis
│   ├── s3.bucket.tf          # Bucket S3 para remote state
│   └── dynamodb.table.tf     # DynamoDB para state locking
│
├── networking/                 # Recursos de rede (VPC completa)
│   ├── main.tf                # Backend e provider configuration
│   ├── variables.tf           # Variáveis de rede
│   ├── outputs.tf             # Outputs dos recursos
│   ├── vpc.tf                 # VPC principal
│   ├── vpc.internet-gateway.tf        # Internet Gateway
│   ├── vpc.public-subnets.tf          # Subnets públicas (2 AZs)
│   ├── vpc.private-subnets.tf         # Subnets privadas (2 AZs)
│   ├── vpc.public-route-tables.tf     # Route tables públicas
│   ├── vpc.private-route-tables.tf    # Route tables privadas
│   ├── vpc.nat-gateways.tf            # NAT Gateways (HA)
│   └── ec2.eips.tf                    # Elastic IPs para NAT
│
├── Server/                     # Recursos de computação (EC2)
│   ├── main.tf                # Backend e provider configuration
│   ├── variables.tf           # Variáveis de EC2
│   ├── outputs.tf             # Outputs (private key)
│   ├── data.vpc.tf            # Data source para VPC
│   ├── data.vpc.private-subnets.tf  # Data source para subnets privadas
│   ├── data.ec2.ami.tf        # Data source para AMI Debian
│   ├── ec2.key-pair.tf        # Key pair para SSH (TLS)
│   ├── ec2.security-groups.tf # Security groups
│   ├── ec2.instace-profile.tf # IAM instance profile e role
│   ├── ec2.instances.control-plane.tf  # Instâncias control plane via módulo
│   ├── ec2.instances.worker.tf         # Instâncias worker via módulo
│   └── modules/
│       └── ec2/               # Módulo reutilizável EC2
│           ├── variables.tf           # Variáveis do módulo
│           ├── ec2.launch-template.tf # Launch template
│           ├── ec2.auto-scaling-group.tf # Auto Scaling Group
│           └── outputs.tf             # Outputs do módulo
│
├── check-terraform.sh          # Script de validação específico
├── check-terraform-generic.sh  # Script de validação genérico
└── terraform.tfvars.example    # Template de variáveis
```

## 🔧 Recursos Provisionados

### Backend Module
- **S3 Bucket**: Armazenamento de Terraform state com versionamento habilitado
- **DynamoDB Table**: State locking para prevenir conflitos
- **IAM Role**: Assume role com external ID para segurança adicional

### Networking Module
- **VPC**: Virtual Private Cloud com CIDR 10.0.0.0/24
- **Subnets Públicas**: 2 subnets em diferentes AZs (us-east-1a, us-east-1b)
- **Subnets Privadas**: 2 subnets em diferentes AZs (us-east-1a, us-east-1b)
- **Internet Gateway**: Acesso à internet para recursos públicos
- **NAT Gateways**: 2 NAT Gateways (um por AZ) para alta disponibilidade
- **Elastic IPs**: IPs fixos para os NAT Gateways
- **Route Tables**: Roteamento público (IGW) e privado (NAT Gateway)
- **Remote State**: Backend S3 configurado para state compartilhado

### Server Module
- **Data Sources**:
  - VPC lookup por tag name
  - Subnets privadas por tag e VPC ID
  - AMI Debian 12 (x86_64) mais recente
- **IAM Resources**:
  - IAM Role para instâncias EC2
  - IAM Instance Profile
  - Policy document para assume role (EC2 service)
- **EC2 Key Pair**: Par de chaves SSH gerado via TLS provider
- **Security Groups**: Regras de firewall para SSH com IP específico
- **Módulo EC2 Reutilizável** (`modules/ec2/`):
  - Launch Template com AMI, instance type, EBS, IAM profile e security groups
  - Auto Scaling Group com health check, maintenance policy e tags
- **Instâncias Control Plane**: Provisionadas via módulo EC2 com variáveis dedicadas
- **Instâncias Worker**: Provisionadas via módulo EC2 com variáveis dedicadas
- **Remote State**: Backend S3 configurado (key: server/terraform.tfstate)

## 🚀 Como Usar

### Pré-requisitos
- Terraform >= 1.9
- AWS CLI configurado
- Credenciais AWS com permissões adequadas

### Providers Utilizados
- **hashicorp/aws** ~> 6.0 - Provider AWS para recursos de infraestrutura
- **hashicorp/tls** ~> 4.0 - Provider TLS para geração de chaves SSH

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

# Networking - Provisionar VPC completa
cd ../networking/
terraform init
terraform plan
terraform apply

# Server - Provisionar recursos de computação
cd ../Server/
terraform init
terraform plan
terraform apply

# Salvar a chave privada (output sensível)
terraform output -raw key_pair_private_key > training-devops-key-pair.pem
chmod 400 training-devops-key-pair.pem
```

### Validando a Configuração

Antes de aplicar, valide sua configuração:

```bash
# Validação específica do projeto
./check-terraform.sh

# Validação genérica (funciona em qualquer estrutura)
./check-terraform-generic.sh
```

## 🔍 Scripts de Validação

### check-terraform.sh
Script específico para este projeto que valida:
- Estrutura de diretórios (backend/ e networking/)
- Profile training_devops configurado
- Backend S3 e state locking
- Arquivos críticos presentes

### check-terraform-generic.sh
Script genérico que se adapta a qualquer estrutura de projeto:
- ✅ Profile no Backend S3
- ✅ Profile no Provider AWS
- ✅ Assume Role (quando necessário)
- ✅ AWS Credentials disponíveis
- ✅ Nome único do Bucket S3
- ✅ Versionamento habilitado
- ✅ State Locking com DynamoDB
- ✅ Segurança (.gitignore e credenciais hardcoded)

Veja [CHECK_TERRAFORM_README.md](CHECK_TERRAFORM_README.md) para mais detalhes.

## 🚀 Uso

```bash
# Download
curl -O https://gist.githubusercontent.com/[seu-user]/[gist-id]/raw/check-terraform-generic.sh

# Tornar executável
chmod +x check-terraform-generic.sh

# Executar no diretório do projeto
./check-terraform-generic.sh
```

## 📊 Exemplo de Saída

```
🔍 Verificando configuração do Terraform...

📁 Arquivos Terraform encontrados:
   ./backend/main.tf
   ./networking/main.tf

🔐 [1/7] Verificando profile no backend...
   ✅ Profile configurado no backend S3

🔐 [2/7] Verificando profile no provider...
   ✅ Profile configurado no provider: production

🎭 [3/7] Verificando assume_role...
   ✅ Assume role configurado

🔑 [4/7] Verificando credentials AWS...
   ✅ Arquivo credentials encontrado (3 profile(s))
   📋 Profiles disponíveis:
      - dev
      - staging
      - production

🪣 [5/7] Verificando configuração do bucket S3...
   📦 Buckets encontrados:
      - terraform-state-mycompany-123456789012
   ✅ Nome de bucket parece único

🔄 [6/7] Verificando versionamento do bucket...
   ✅ Versionamento habilitado no bucket

🔒 [7/7] Verificando state locking...
   ✅ State locking configurado (DynamoDB)

🔒 BONUS: Verificando segurança...
   ✅ Arquivos sensíveis no .gitignore

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Todas as verificações passaram!
   Projeto configurado corretamente!
```

## 🏗️ Estruturas Suportadas

O script funciona com **qualquer** estrutura de projeto:

### Estrutura Simples (Flat)
```
.
├── main.tf
├── variables.tf
└── terraform.tfvars
```

### Estrutura Modular
```
.
├── backend/
│   ├── main.tf
│   ├── variables.tf
│   └── dynamodb.tf
├── networking/
│   ├── main.tf
│   └── vpc.tf
└── modules/
    └── ...
```

### Estrutura por Ambiente
```
.
├── environments/
│   ├── dev/
│   │   └── main.tf
│   ├── staging/
│   │   └── main.tf
│   └── prod/
│       └── main.tf
└── modules/
```

### Estrutura Complexa
```
.
├── infrastructure/
│   ├── aws/
│   │   ├── backend/
│   │   └── networking/
│   └── modules/
└── terraform/
    └── ...
```

**Funciona em todas!** 🎉

## 🔧 Integração CI/CD

### GitHub Actions

```yaml
name: Terraform Validation

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Download checker
        run: curl -O https://gist.githubusercontent.com/[seu-user]/[gist-id]/raw/check-terraform-generic.sh
      
      - name: Validate Terraform Config
        run: |
          chmod +x check-terraform-generic.sh
          ./check-terraform-generic.sh
```

### GitLab CI

```yaml
terraform-check:
  stage: validate
  script:
    - curl -O https://gist.githubusercontent.com/[seu-user]/[gist-id]/raw/check-terraform-generic.sh
    - chmod +x check-terraform-generic.sh
    - ./check-terraform-generic.sh
```

### Pre-commit Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash
./check-terraform-generic.sh || exit 1
```

## ⚠️ Códigos de Saída

- `0` - ✅ Sucesso (sem erros, pode ter avisos)
- `1` - ❌ Falha (erros críticos encontrados)

## 🎨 Personalização

Você pode ajustar o comportamento editando as variáveis:

```bash
ERRORS=0      # Incrementa para bloquear execução
WARNINGS=0    # Incrementa apenas para alertar
```

## 📚 Checklist Completo

Use este checklist antes de fazer deploy:

- [ ] Profile configurado no backend S3
- [ ] Profile configurado no provider AWS
- [ ] Assume role configurado (se necessário)
- [ ] Credentials AWS disponíveis localmente
- [ ] Bucket S3 com nome globalmente único
- [ ] Versionamento habilitado no bucket
- [ ] State locking com DynamoDB
- [ ] Arquivos .tfvars no .gitignore
- [ ] Arquivos .tfstate no .gitignore
- [ ] Sem credenciais hardcoded no código

## 🔒 Segurança

Este projeto implementa as seguintes práticas de segurança:

✅ **Separação de credenciais**: Valores sensíveis em `terraform.tfvars` (não versionado)  
✅ **GitIgnore robusto**: Proteção contra commit acidental de secrets  
✅ **IAM Assume Role**: Uso de roles com external ID  
✅ **Remote State**: State armazenado em S3 com versionamento  
✅ **No hardcoded secrets**: Todas as credenciais via variáveis  
✅ **Scripts de validação**: Verificação automática de configurações

### Arquivos Protegidos (não versionados)
- `*.tfvars` - Credenciais e valores sensíveis
- `*.tfstate` - Estado da infraestrutura
- `.terraform/` - Dependências e cache

## 📚 Conceitos Aplicados

- **Infrastructure as Code (IaC)**: Infraestrutura versionada e reproduzível
- **High Availability**: NAT Gateways em múltiplas AZs
- **Network Segmentation**: Subnets públicas e privadas isoladas
- **Remote State**: Compartilhamento seguro do state entre equipes
- **Modularização**: Módulo EC2 reutilizável para diferentes tipos de instância
- **Variables**: Parametrização para diferentes ambientes
- **Dynamic Resources**: Uso de count para criar recursos escaláveis
- **Security Best Practices**: Proteção de credenciais e secrets
- **Automation**: Scripts de validação e verificação

## 📅 Histórico de Desenvolvimento

### 14/03/2026 - Modularização EC2: Control Plane e Workers
**Refatoração e novos recursos:**

#### 🏗️ Módulo EC2 Reutilizável
- ✅ **Criação do módulo `modules/ec2/`**: Launch Template + Auto Scaling Group encapsulados
- ✅ **Instâncias Control Plane**: Provisionadas via módulo com variáveis dedicadas
- ✅ **Instâncias Worker**: Provisionadas via módulo com variáveis dedicadas
- ✅ **Princípio DRY**: Mesmo módulo reutilizado para control plane e workers

#### 🐛 Correções
- ✅ **Fix: Typo `auto_sacaling_group`** → `auto_scaling_group` em todos os arquivos
- ✅ **Fix: Nomes de campos inconsistentes** (`min_healthy_percentage` → `min_healthy_percent`)
- ✅ **Fix: Referência incorreta do instance profile** no módulo
- ✅ **Fix: Launch template version** `$latest` → `$Latest` (case-sensitive na AWS)
- ✅ **Fix: Worker usando variáveis do control plane** → corrigido para variáveis worker
- ✅ **Fix: Output com typo** `auto_sacaling_group_name` → `auto_scaling_group_name`
- ✅ **Fix: Tags default vazias** → adicionados valores default para Project e Environment

#### 📝 Boas Práticas
- ✅ **8 commits atômicos** com mensagens descritivas seguindo conventional commits
- ✅ **Verificação de credenciais** antes do push
- ✅ **Terraform apply com sucesso** na AWS

**Commits**: a23572d, 7f76f66, df3c2a7, 51046ff, 05f005f, 6ed3a39, f8d1bde, 0a207a7

### 07/03/2026 - Correções e Refinamentos no Launch Template
**Debugging e correções realizadas:**

#### 🐛 Correções de Erros
- ✅ **Fix: Data Source aws_ami**
  - Problema: Atributo `architecture` não é configurável diretamente
  - Solução: Movido para filter block
  - Aprendizado: Diferença entre atributos computados e configuráveis

- ✅ **Fix: Typo em shutdown_behavior**
  - Problema: "terninate" em vez de "terminate"
  - Solução: Correção do typo na variável
  - Aprendizado: AWS valida rigorosamente valores de enum

- ✅ **Fix: Tag Specifications vazias**
  - Problema: AWS rejeita tags nulas/vazias
  - Solução: Dynamic block condicional
  - Aprendizado: APIs têm opiniões fortes sobre dados vazios

#### 📝 Boas Práticas Aplicadas
- ✅ **Commits Atômicos**: 3 commits individuais com mensagens descritivas
- ✅ **Segurança**: Verificação de credenciais antes do push
- ✅ **Documentação**: README atualizado com aprendizados

**Commits**: be86629, fc9b841, 44302ef

### 06/03/2026 - Finalização do Módulo Server
**Implementações realizadas:**

#### 🖥️ Recursos de Computação Finalizados
- ✅ **Data Source VPC**: Busca VPC por tag name
- ✅ **Security Group SSH**: Regras de firewall com IP específico
- ✅ **Key Pair Generation**: Geração de chaves via TLS provider
- ✅ **Variáveis Atualizadas**: Estrutura completa para EC2 e VPC resources

#### 📝 Configuração
- ✅ **Comentários no tfvars**: Documentação sobre assume_role

**Commits**: 73a5be4, 1ee2922, 11d7bb2, fbcf46c, 5d8a6ca

### 05/03/2026 - IAM Resources para EC2
**Implementações realizadas:**

#### 🔐 IAM Infrastructure
- ✅ **IAM Instance Profile**: Profile para anexar role às instâncias
- ✅ **IAM Role**: Role com assume role policy para EC2 service
- ✅ **Policy Document**: Documento de política para EC2 assumir role
- ✅ **Variáveis Expandidas**: Nomes de instance profile e role parametrizados

**Commits**: 8bde1d9, 8fdadd6

### 04/03/2026 - Início do Módulo Server
**Implementações realizadas:**

#### 🚀 Estrutura Base do Server Module
- ✅ **Configuração Base**: Backend S3 e provider AWS
- ✅ **Variáveis**: Estrutura de variáveis para recursos EC2
- ✅ **Key Pair**: Recurso TLS para geração de chaves SSH
- ✅ **Output Sensível**: Private key como output sensível

#### 🏗️ Arquitetura Inicial
```
Server/
├── main.tf (backend + provider)
├── variables.tf
├── outputs.tf
├── ec2.key-pair.tf
└── ec2.instace-profile.tf
```

**Commits**: 78bb06f, bade6f0, 9b31788, 6939d86

### 03/03/2026 - Expansão da Arquitetura de Rede
**Implementações realizadas:**

#### 🌐 Infraestrutura de Rede Completa
- ✅ **Subnets Públicas**: Implementadas 2 subnets públicas em AZs diferentes (us-east-1a, us-east-1b)
  - CIDR: 10.0.0.0/27 e 10.0.0.64/27
  - Auto-assign de IPs públicos habilitado
  - Recursos dinâmicos com `count`

- ✅ **Subnets Privadas**: Implementadas 2 subnets privadas em AZs diferentes
  - CIDR: 10.0.0.32/27 e 10.0.0.96/27
  - Isolamento de recursos internos
  - Recursos dinâmicos com `count`

- ✅ **NAT Gateways**: Configuração de alta disponibilidade
  - 1 NAT Gateway por AZ (total: 2)
  - Elastic IPs dedicados para cada NAT
  - Dependência explícita do Internet Gateway

- ✅ **Route Tables**: Roteamento completo e segregado
  - Route table pública única (rota para IGW)
  - Route tables privadas individuais (rota para NAT Gateway específico)
  - Associações automáticas com subnets

#### 🔧 Melhorias de Código
- ✅ **Variáveis Expandidas**: Estrutura de dados completa para VPC
  - Configuração de subnets públicas e privadas
  - Nomes de recursos parametrizados
  - Valores padrão para 2 AZs

- ✅ **Outputs Adicionados**: Exportação de IDs de recursos
  - NAT Gateway IDs
  - Public Subnet IDs
  - Private Subnet IDs

#### 📝 Documentação e Automação
- ✅ **Scripts de Validação**: 2 scripts criados
  - `check-terraform.sh`: Validação específica do projeto
  - `check-terraform-generic.sh`: Validação genérica adaptável

- ✅ **Documentação Completa**:
  - `CHECK_TERRAFORM_README.md`: Guia dos scripts de validação
  - `LINKEDIN_RESPONSE.md`: Sugestões de comunicação técnica
  - README atualizado com estrutura completa

#### 🎯 Arquitetura Resultante
```
VPC (10.0.0.0/24)
├── Internet Gateway
├── Public Subnets (2)
│   ├── us-east-1a (10.0.0.0/27)
│   └── us-east-1b (10.0.0.64/27)
├── Private Subnets (2)
│   ├── us-east-1a (10.0.0.32/27)
│   └── us-east-1b (10.0.0.96/27)
├── NAT Gateways (2)
│   ├── NAT-1a (com EIP)
│   └── NAT-1b (com EIP)
└── Route Tables
    ├── Public RT → IGW
    ├── Private RT 1a → NAT-1a
    └── Private RT 1b → NAT-1b
```

#### ✅ Validação e Testes
- ✅ **Terraform Apply**: Infraestrutura provisionada com sucesso na AWS
  - Todos os recursos criados sem erros
  - VPC, Subnets, NAT Gateways, Route Tables validados
  - Conectividade testada e funcionando

- ✅ **Verificação na Console AWS**: Recursos validados visualmente
  - VPC criada com CIDR correto
  - Subnets públicas e privadas em AZs diferentes
  - NAT Gateways ativos com EIPs associados
  - Route Tables com rotas corretas

- ✅ **Terraform Destroy**: Limpeza completa da infraestrutura
  - Todos os recursos removidos com sucesso
  - Sem recursos órfãos ou custos residuais
  - State limpo e consistente

**Commits realizados**: 13 commits individuais seguindo conventional commits

## 🎯 Objetivos de Aprendizado

- [x] Configurar provider AWS com assume role
- [x] Criar e gerenciar remote state em S3
- [x] Provisionar recursos de rede (VPC)
- [x] Implementar segurança no versionamento de código
- [x] Estruturar projeto Terraform modular
- [x] Implementar subnets públicas e privadas em múltiplas AZs
- [x] Configurar NAT Gateways para alta disponibilidade
- [x] Criar scripts de validação e automação
- [x] Documentar arquitetura e processos
- [x] Configurar EC2 Launch Templates
- [x] Implementar data sources para AMIs
- [x] Debugar erros comuns do Terraform/AWS
- [x] Adicionar Auto Scaling Groups
- [x] Modularizar recursos EC2 (módulo reutilizável)
- [ ] Implementar CI/CD com GitHub Actions
- [ ] Adicionar testes de infraestrutura (Terratest)

## 🤝 Contribuindo

Encontrou um bug? Tem uma sugestão?

- Abra uma issue
- Faça um fork e envie um PR
- Compartilhe com a comunidade!

## 📝 Licença

MIT License - Use livremente!

## 💡 Inspiração

Criado a partir de discussões na comunidade DevOps sobre as dificuldades de trabalhar com múltiplas contas AWS.

---

**Feito com ❤️ para a comunidade DevOps**

Se este script te ajudou, considere:
- ⭐ Dar uma estrela no Gist
- 🔄 Compartilhar com seu time
- 💬 Deixar feedback

## 🔗 Links Úteis

- [Terraform Backend Configuration](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [AWS Multi-Account Strategy](https://aws.amazon.com/organizations/getting-started/best-practices/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

**Versão:** 1.0.0  
**Última atualização:** Março 2026  
**Autor:** Jean Porto

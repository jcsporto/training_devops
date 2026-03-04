# 🔍 Terraform Multi-Account Checker

Script genérico e inteligente para validar configurações Terraform em projetos AWS multi-account.

**Adapta-se automaticamente** à estrutura do seu projeto - funciona em qualquer organização de código!

## 🎯 O que ele valida?

- ✅ **Profile no Backend S3** - Evita usar credenciais erradas
- ✅ **Profile no Provider AWS** - Garante consistência
- ✅ **Assume Role** - Valida configuração cross-account
- ✅ **AWS Credentials** - Verifica profiles disponíveis
- ✅ **Nome do Bucket S3** - Alerta sobre nomes genéricos
- ✅ **Versionamento** - Recomenda backup do state
- ✅ **State Locking** - Valida DynamoDB configurado
- ✅ **Segurança** - Verifica .gitignore e credenciais hardcoded

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

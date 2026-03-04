# 🔍 Check Terraform - Script Genérico

Script inteligente para validar configurações Terraform em projetos AWS multi-account.

## 🎯 O que ele faz?

Adapta-se automaticamente à estrutura do seu projeto e valida:

- ✅ Profile configurado no backend S3
- ✅ Profile configurado no provider AWS
- ✅ Assume role (quando necessário)
- ✅ Credentials AWS disponíveis
- ✅ Nome único do bucket S3
- ✅ Versionamento habilitado
- ✅ State locking com DynamoDB
- ✅ Segurança (.gitignore configurado)

## 🚀 Como usar

```bash
# Tornar executável (primeira vez)
chmod +x check-terraform-generic.sh

# Executar
./check-terraform-generic.sh
```

## 📋 Exemplo de saída

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
   ✅ Nome de bucket parece único

🔄 [6/7] Verificando versionamento do bucket...
   ✅ Versionamento habilitado no bucket

🔒 [7/7] Verificando state locking...
   ✅ State locking configurado (DynamoDB)

🔒 BONUS: Verificando segurança...
   ✅ Arquivos sensíveis no .gitignore

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Todas as verificações passaram!
```

## 🏗️ Estruturas suportadas

O script funciona com qualquer estrutura:

### Estrutura simples
```
.
├── main.tf
├── variables.tf
└── backend.tf
```

### Estrutura modular
```
.
├── backend/
│   ├── main.tf
│   └── variables.tf
├── networking/
│   ├── main.tf
│   └── variables.tf
└── modules/
    └── ...
```

### Estrutura por ambiente
```
.
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
└── modules/
```

## ⚠️ Códigos de saída

- `0` - Tudo OK ou apenas avisos
- `1` - Erros encontrados

## 🔧 Personalização

Você pode ajustar os níveis de severidade editando o script:

- `ERRORS` - Bloqueia execução
- `WARNINGS` - Apenas alerta

## 📦 Compartilhamento

Sinta-se livre para compartilhar e adaptar este script!

Criado para a comunidade DevOps 💙

---

**Dica:** Adicione ao seu CI/CD para validar PRs automaticamente!

```yaml
# .github/workflows/terraform-check.yml
- name: Validate Terraform Config
  run: ./check-terraform-generic.sh
```

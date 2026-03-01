# Como subir para o GitHub com segurança

## Passo a passo:

### 1. Inicializar repositório Git (se ainda não fez)
```bash
cd devops-training
git init
```

### 2. Verificar se o .gitignore está funcionando
```bash
git status
# Certifique-se que terraform.tfvars NÃO aparece na lista
```

### 3. Adicionar arquivos
```bash
git add .
```

### 4. Fazer o primeiro commit
```bash
git commit -m "Initial commit: Terraform infrastructure setup"
```

### 5. Criar repositório no GitHub
- Acesse https://github.com/new
- Crie um repositório (pode ser privado para mais segurança)
- NÃO inicialize com README (já temos um)

### 6. Conectar ao repositório remoto
```bash
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git branch -M main
git push -u origin main
```

## Verificação de Segurança

Antes de fazer push, verifique:
```bash
# Ver o que será commitado
git diff --cached

# Procurar por possíveis credenciais
git grep -i "password\|secret\|key" $(git diff --cached --name-only)
```

## Dica Extra: Use git-secrets

Instale o git-secrets para prevenir commits acidentais de credenciais:
```bash
# No Ubuntu/Debian
sudo apt-get install git-secrets

# Configurar no repositório
git secrets --install
git secrets --register-aws
```

#!/bin/bash
# check-terraform-generic.sh
# Script genérico para validar configuração Terraform multi-account AWS
# Adapta-se automaticamente à estrutura do projeto

echo "🔍 Verificando configuração do Terraform..."
echo ""

ERRORS=0
WARNINGS=0

# Função para buscar arquivos .tf recursivamente
find_tf_files() {
    find . -name "*.tf" -not -path "*/.terraform/*" 2>/dev/null
}

# Verifica se há arquivos Terraform no projeto
TF_FILES=$(find_tf_files)
if [ -z "$TF_FILES" ]; then
    echo "❌ Nenhum arquivo .tf encontrado no projeto!"
    exit 1
fi

echo "📁 Arquivos Terraform encontrados:"
echo "$TF_FILES" | sed 's/^/   /'
echo ""

# 1. Verifica profile no BACKEND
echo "🔐 [1/7] Verificando profile no backend..."
if grep -rq "backend.*\"s3\"" . --include="*.tf" 2>/dev/null; then
    if grep -rq "profile.*=" . --include="*.tf" | grep -q "backend" -A 10 2>/dev/null || \
       grep -A 10 "backend.*\"s3\"" $(find_tf_files) | grep -q "profile"; then
        echo "   ✅ Profile configurado no backend S3"
    else
        echo "   ⚠️  Backend S3 encontrado mas profile não especificado"
        echo "      Adicione: profile = \"seu-profile\""
        ((WARNINGS++))
    fi
else
    echo "   ℹ️  Backend S3 não encontrado (pode estar usando backend local)"
fi

# 2. Verifica profile no PROVIDER
echo ""
echo "🔐 [2/7] Verificando profile no provider..."
if grep -rq "provider.*\"aws\"" . --include="*.tf" 2>/dev/null; then
    if grep -A 10 "provider.*\"aws\"" $(find_tf_files) | grep -q "profile"; then
        PROFILE=$(grep -A 10 "provider.*\"aws\"" $(find_tf_files) | grep "profile" | head -1 | sed 's/.*=//;s/[" ]//g')
        echo "   ✅ Profile configurado no provider: $PROFILE"
    else
        echo "   ⚠️  Provider AWS encontrado mas profile não especificado"
        echo "      Adicione: profile = \"seu-profile\""
        ((WARNINGS++))
    fi
else
    echo "   ❌ Provider AWS não encontrado!"
    ((ERRORS++))
fi

# 3. Verifica Assume Role
echo ""
echo "🎭 [3/7] Verificando assume_role..."
if grep -rq "assume_role" . --include="*.tf" 2>/dev/null; then
    if grep -A 5 "assume_role" $(find_tf_files) | grep -q "role_arn"; then
        echo "   ✅ Assume role configurado"
    else
        echo "   ⚠️  Bloco assume_role encontrado mas role_arn não especificado"
        ((WARNINGS++))
    fi
else
    echo "   ℹ️  Assume role não configurado (opcional)"
fi

# 4. Verifica configuração de credentials
echo ""
echo "🔑 [4/7] Verificando credentials AWS..."
if [ -f ~/.aws/credentials ]; then
    PROFILES=$(grep '^\[' ~/.aws/credentials | tr -d '[]' | wc -l)
    echo "   ✅ Arquivo credentials encontrado ($PROFILES profile(s))"
    
    # Lista profiles encontrados
    if [ $PROFILES -gt 0 ]; then
        echo "   📋 Profiles disponíveis:"
        grep '^\[' ~/.aws/credentials | tr -d '[]' | sed 's/^/      - /'
    fi
else
    echo "   ⚠️  Arquivo ~/.aws/credentials não encontrado"
    ((WARNINGS++))
fi

# 5. Verifica bucket S3 (nome único)
echo ""
echo "🪣 [5/7] Verificando configuração do bucket S3..."
if grep -rq "bucket.*=" . --include="*.tf" 2>/dev/null; then
    BUCKETS=$(grep -r "bucket.*=" . --include="*.tf" | grep -v "aws_s3_bucket" | grep "backend" -A 5 | grep "bucket" | sed 's/.*=//;s/[" ]//g')
    
    if [ ! -z "$BUCKETS" ]; then
        echo "   📦 Buckets encontrados:"
        echo "$BUCKETS" | sed 's/^/      - /'
        
        # Verifica se tem nome genérico
        if echo "$BUCKETS" | grep -qE "^(terraform-state|tfstate|state)$"; then
            echo "   ⚠️  Nome de bucket muito genérico! Use algo único:"
            echo "      terraform-state-<empresa>-<account-id>"
            ((WARNINGS++))
        else
            echo "   ✅ Nome de bucket parece único"
        fi
    fi
fi

# 6. Verifica versionamento do bucket
echo ""
echo "🔄 [6/7] Verificando versionamento do bucket..."
if grep -rq "aws_s3_bucket_versioning" . --include="*.tf" 2>/dev/null; then
    if grep -A 5 "aws_s3_bucket_versioning" $(find_tf_files) | grep -q "Enabled"; then
        echo "   ✅ Versionamento habilitado no bucket"
    else
        echo "   ⚠️  Recurso de versionamento encontrado mas não habilitado"
        ((WARNINGS++))
    fi
else
    echo "   ⚠️  Versionamento não configurado (recomendado para produção)"
    echo "      Adicione: aws_s3_bucket_versioning com status = \"Enabled\""
    ((WARNINGS++))
fi

# 7. Verifica state locking (DynamoDB)
echo ""
echo "🔒 [7/7] Verificando state locking..."
if grep -rq "dynamodb_table" . --include="*.tf" 2>/dev/null; then
    echo "   ✅ State locking configurado (DynamoDB)"
else
    echo "   ⚠️  State locking não configurado"
    echo "      Recomendado: adicione dynamodb_table no backend S3"
    ((WARNINGS++))
fi

# BONUS: Verifica segurança
echo ""
echo "🔒 BONUS: Verificando segurança..."

if [ -f .gitignore ]; then
    if grep -q "*.tfvars" .gitignore && grep -q "*.tfstate" .gitignore; then
        echo "   ✅ Arquivos sensíveis no .gitignore"
    else
        echo "   ⚠️  .gitignore incompleto! Adicione:"
        [ ! grep -q "*.tfvars" .gitignore ] && echo "      *.tfvars"
        [ ! grep -q "*.tfstate" .gitignore ] && echo "      *.tfstate"
        ((WARNINGS++))
    fi
else
    echo "   ⚠️  Arquivo .gitignore não encontrado!"
    ((WARNINGS++))
fi

# Verifica se há credenciais hardcoded
if grep -rq "aws_access_key_id\|aws_secret_access_key" . --include="*.tf" 2>/dev/null; then
    echo "   ❌ ALERTA: Possíveis credenciais hardcoded encontradas!"
    ((ERRORS++))
fi

# Resumo final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "🎉 Todas as verificações passaram!"
    echo "   Projeto configurado corretamente!"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Validação concluída com $WARNINGS aviso(s)"
    echo "   Projeto funcional, mas pode ser melhorado"
    exit 0
else
    echo "❌ Validação falhou!"
    echo "   Erros: $ERRORS | Avisos: $WARNINGS"
    exit 1
fi

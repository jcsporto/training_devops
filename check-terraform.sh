#!/bin/bash
# check-terraform.sh - Valida configuração do Terraform

echo "🔍 Verificando configuração do Terraform..."
echo ""

ERRORS=0

# Verifica estrutura de diretórios
if [ ! -d "networking" ] || [ ! -d "backend" ]; then
    echo "❌ Estrutura de diretórios incompleta!"
    exit 1
fi

# Verifica profile no backend (networking/main.tf)
echo "📁 Verificando networking/main.tf..."
if ! grep -q "profile.*=.*\"training_devops\"" networking/main.tf; then
    echo "   ❌ Profile 'training_devops' não encontrado no backend!"
    ((ERRORS++))
else
    echo "   ✅ Profile configurado no backend"
fi

# Verifica backend S3
if ! grep -q "backend.*\"s3\"" networking/main.tf; then
    echo "   ❌ Backend S3 não configurado!"
    ((ERRORS++))
else
    echo "   ✅ Backend S3 configurado"
fi

# Verifica state locking (dynamodb_table)
if ! grep -q "dynamodb_table" networking/main.tf; then
    echo "   ⚠️  State locking não encontrado!"
    ((ERRORS++))
else
    echo "   ✅ State locking habilitado"
fi

# Verifica provider AWS
if ! grep -q "provider.*\"aws\"" networking/main.tf; then
    echo "   ❌ Provider AWS não encontrado!"
    ((ERRORS++))
else
    echo "   ✅ Provider AWS configurado"
fi

echo ""
echo "📁 Verificando backend/..."

# Verifica DynamoDB table
if [ ! -f "backend/dynamodb.table.tf" ]; then
    echo "   ❌ Arquivo dynamodb.table.tf não encontrado!"
    ((ERRORS++))
else
    echo "   ✅ DynamoDB table configurado"
fi

# Verifica variáveis
if [ ! -f "backend/variables.tf" ]; then
    echo "   ❌ Arquivo variables.tf não encontrado!"
    ((ERRORS++))
else
    if grep -q "state_locking" backend/variables.tf; then
        echo "   ✅ Variáveis de state locking definidas"
    else
        echo "   ⚠️  Variáveis de state locking não encontradas"
        ((ERRORS++))
    fi
fi

# Verifica se .tfvars está no .gitignore
echo ""
echo "🔒 Verificando segurança..."
if grep -q "*.tfvars" .gitignore; then
    echo "   ✅ Arquivos .tfvars estão no .gitignore"
else
    echo "   ⚠️  Arquivos .tfvars não estão no .gitignore!"
fi

echo ""
if [ $ERRORS -gt 0 ]; then
    echo "❌ Validação falhou com $ERRORS erro(s)!"
    exit 1
else
    echo "🎉 Todas as verificações passaram!"
    echo "   Projeto configurado corretamente!"
fi

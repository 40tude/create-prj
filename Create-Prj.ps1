# PowerShell script to create a project structure

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName
)

# Convert project name to lowercase
$projectName = $ProjectName.ToLower()

# Define project structure
$baseDir = ".\$projectName"
$directories = @(
    "$baseDir",
    "$baseDir\src",
    "$baseDir\tests",
    "$baseDir\docs"
)
$files = @(
    "$baseDir\$projectName.py",
    "$baseDir\README.md",
    "$baseDir\requirements.txt",
    "$baseDir\setup.py",
    "$baseDir\.gitignore",
    "$baseDir\LICENSE",
    "$baseDir\.env",
    "$baseDir\src\__init__.py",
    "$baseDir\src\mod1.py",
    "$baseDir\src\mod2.py",
    "$baseDir\tests\test_mod1.py",
    "$baseDir\tests\test_mod2.py",
    "$baseDir\tests\conftest.py",
    "$baseDir\docs\index.md"
)

# Create directories
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory | Out-Null
    }
}

# Create files
foreach ($file in $files) {
    if (-not (Test-Path $file)) {
        New-Item -Path $file -ItemType File | Out-Null
    }
}

# Add content to key files
Set-Content "$baseDir\README.md" "# $ProjectName`n`nProject description."

Set-Content "$baseDir\.env" @"
# .env
# ! This file must be listed in .gitignore

# Example
SMTP_USER=philippe.baucour@gmail.com
"@

Set-Content "$baseDir\.gitignore" @"
# .gitignore

# -----------------------------------------------------------------------------
# files to ignore
secrets.ps1
.env
Jenkinsfile
*.log

# too big
data.xlsx

# -----------------------------------------------------------------------------
# directories to ignore
.git/
.vscode/

# "**/.mypy_cache/" ignore all directories named ".mypy_cache/""
**/.mypy_cache/
**/.pytest_cache/
**/__pycache__/
**/mlruns/ 
**/logs/



# Large files Size > 100MB (warning at 50MB)
# No way to specify the size in .gitignore
# Get-ChildItem ./ -recurse | where-object {$_.length -gt 100000000} | Sort-Object length | ft fullname, length -auto

# Add below the large files listed with the previous command
# Initially, fraud_test.csv is available here: https://app.jedha.co/course/final-projects-l/automatic-fraud-detection-l
# No need to list it since we already exclude ./data directory
# fraud_test.csv

###############################################################################
# This may help

# Project stats : 
#   Total number of files
#   Get-ChildItem -Recurse -File | Measure-Object | Select-Object -ExpandProperty Count

#   Count the number of files with the extension
#   Get-ChildItem -Path "./" -Recurse -Filter "*.py" | Measure-Object | Select-Object -ExpandProperty Count

#   Count the number of lines of python code
#   Get-ChildItem -Recurse -Filter "*.py" | Get-Content | Measure-Object -Line | Select-Object -ExpandProperty Lines




# Display all files secret*.*
# Get-ChildItem -Path . -Recurse -Force -Filter "secret*.*" | ForEach-Object { $_.FullName } 

# Find the project directory size - GitHub 5GB max
# (Get-ChildItem . -Recurse | Measure-Object -Property Length -sum).sum/1GB

# Search for files containing the pattern "AWS_SECRET_ACCESS_KEY" and display the file paths where this pattern is found
# Get-ChildItem -Recurse -File | Select-String -Pattern "AWS_SECRET_ACCESS_KEY" | Select-Object -ExpandProperty Path

# List the 20 largest files in a directory and its subdirectories
# Get-ChildItem -Path . -Recurse | Sort-Object Length -Descending | Select-Object FullName, Length -First 20

# Search for directories named .aws in the current directory and its subdirectories
# Get-ChildItem -Path . -Directory -Recurse -Force | Where-Object { $_.Name -eq ".aws" }

# List all PNG files in a directory and its subdirectories, then display their full paths
# Get-ChildItem -Path . -Filter *.png -Recurse | Select-Object -ExpandProperty FullName

# No longer needed as they no longer exist
# secrets.sh
# secrets.yaml
# python.config

# .aws/
# *.aws
# files like my-keypair.pem (AWS key)
# *.pem

# Docker Compose environment variables
# See https://app.jedha.co/course/docker-reminders-l/docker-compose-l
# *.env 
# *.pyc
"@

Set-Content "$baseDir\requirements.txt" "# Add your dependencies here
pytest
mypy"

Set-Content "$baseDir\setup.py" "from setuptools import setup

setup(
    name='$projectName',
    version='0.1',
    packages=['src'],
    install_requires=[],
)"
Set-Content "$baseDir\docs\index.md" "# Documentation

Write your documentation here."

Write-Host "Project '$ProjectName' has been created successfully at $baseDir."

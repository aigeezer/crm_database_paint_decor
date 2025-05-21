#!/bin/bash

# Fixed GitHub repository setup script for CRM Database for Painting and Decorating Companies

# Variables
REPO_NAME="crm_database_paint_decor"
DESCRIPTION="A comprehensive CRM database system for painting and decorating contractors"
WORKSPACE_DIR="/Users/tony/${REPO_NAME}"
GITHUB_USER="aigeezer"

echo "====== CRM Database GitHub Repository Setup ======"
echo "This script will help you create and push to a GitHub repository"
echo "without requiring the GitHub CLI"
echo ""
echo "Please follow these steps:"
echo ""
echo "1. First, create a new repository on GitHub:"
echo "   a. Visit: https://github.com/new"
echo "   b. Repository name: ${REPO_NAME}"
echo "   c. Description: ${DESCRIPTION}"
echo "   d. Choose Private or Public as you prefer"
echo "   e. DO NOT initialize with README or other files"
echo "   f. Click 'Create repository'"
echo ""
echo "Press Enter after you've created the repository on GitHub..."
read -p "" confirm

# Check if we're in the correct directory
cd "$WORKSPACE_DIR" || { echo "Error: Could not change to directory $WORKSPACE_DIR"; exit 1; }
echo "Working directory: $(pwd)"

# Check if git is initialized
if [ ! -d ".git" ]; then
  echo "Initializing Git repository..."
  git init
fi

# Check if remote exists and update if needed
if git remote | grep -q "^origin$"; then
  echo "Remote 'origin' already exists. Updating URL..."
  git remote set-url origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
else
  echo "Adding remote 'origin'..."
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
fi

# Check for changes to add
if ! git diff --quiet || ! git diff --staged --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo "Adding all files to git..."
  git add .
  git commit -m "Initial commit with database schema and documentation"
fi

# Get current branch name
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
echo "Current branch is: $CURRENT_BRANCH"

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin "$CURRENT_BRANCH"

echo ""
echo "Repository setup complete!"
echo "Your repository is available at: https://github.com/$GITHUB_USER/$REPO_NAME"

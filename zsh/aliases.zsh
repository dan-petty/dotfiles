# =============================================================================
# Shell Aliases (aliases.zsh)
# =============================================================================

# Navigation & Directory
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll="ls -la --color=auto"
alias l="ls -lh --color=auto"

# Git
alias g="git"
alias gst="git status -sb"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gaa="git add -A"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --graph --decorate -n 20"
alias gd="git diff"
alias gds="git diff --staged"

# Kubernetes / Helm
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kga="kubectl get all"
alias kgn="kubectl get nodes"
alias kl="kubectl logs"
alias kex="kubectl exec -it"
alias kctx="kubectl config current-context"

# Python & uv
alias uvp="uv python"
alias uvr="uv run"
alias uvs="uv sync"
alias uvt="uv run pytest"

# DevOps CLI
alias d="devops"
alias dci="devops ci"
alias drev="devops ai review"
alias dk8s="devops k8s"

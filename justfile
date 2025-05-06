# ====== Configuration ======
PYTHON := "python3"
SECRETS := ".secrets"
PYTHON_REQUIRED := "3.12"

# ====== Default recipe ======
default:
    just help

# ====== Tasks ======

check-python:
    @version=$({{PYTHON}} --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') && \
    echo "Using Python $version" && \
    echo "$version" | grep -q '^{{PYTHON_REQUIRED}}' || \
    (echo "Python {{PYTHON_REQUIRED}} is required, but found $version" && exit 1)

check-scripts:
    @echo "🔍 Running Python pre-commit check script..."
    {{PYTHON}} -m scripts.pre_commit_check

precommit:
    @echo "Running pre-commit on changed files..."
    pre-commit run --from-ref origin/main --to-ref HEAD

precommit-all:
    @echo "Running pre-commit on ALL files..."
    pre-commit run --all-files

check-file: 
    @echo "Checking file integrity..."
    just check-python
    just check-scripts
    just precommit

check-project:
    @echo "Checking project integrity..."
    just check-python
    just check-scripts
    just precommit-all

ci-build:
    @echo "Simulating GitHub Actions with act for docker build..."
    act workflow_dispatch -j release -e .github/mock-events/docker_build.json

ci-precommit branch="main":
    @echo "Simulating GitHub Actions with act for branch {{branch}}..."
    act pull_request --env GITHUB_REF=refs/heads/{{branch}}

ci-semantic:
    @echo "Simulating 'workflow run' for semantic release..."
    act workflow_dispatch -j release -e .github/mock-events/semantic_release.json

ci-stale:
    @echo "Simulating 'Mark stale issues and pull requests' workflow..."
    act workflow_dispatch --job stale



# Show available commands
help:
    @echo ""
    @echo "Available commands:"
    @echo "  just check-file        - Run fast local pre-commit check"
    @echo "  just check-project     - Run full local pre-commit check"
    @echo "  just ci-stale          - Simulate Github Actions for stale issues and PRs"
    @echo "  just ci-precommit      - Simulate GitHub Actions for pre-commit on a specific branch"
    @echo "  just ci-semantic       - Simulate Github Actions for semantic release"
    @echo "  just ci-build          - Simulate GitHub Actions for docker build"
    @echo "  just help              - Show this help menu"
    @echo ""

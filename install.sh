#!/bin/bash

detect_shell() {
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        local parent_shell=$(ps -p $PPID -o comm=)
        case "$parent_shell" in
            *bash*) echo "bash" ;;
            *) echo "unknown" ;;
        esac
    fi
}

shell_type=$(detect_shell)

if [[ "$shell_type" != "bash" ]]; then
    echo "ERROR: Unsupported shell. Currently only bash is supported."
    exit 1
fi

script_name="clam.sh"
install_path="$HOME/.local/bin/$script_name"

if [ ! -d "$(dirname "$install_path")" ]; then
    install_path="/usr/local/bin/$script_name"
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$script_dir/clam.sh" "$install_path"
chmod +x "$install_path"

symlink_path="$(dirname "$install_path")/clam"
rm -f "$symlink_path"
ln -s "$install_path" "$symlink_path"

if ! command -v jq > /dev/null 2>&1; then
    echo "ERROR: jq is not installed. Please install jq to continue."
    echo "For Ubuntu/Debian: sudo apt-get install jq"
    echo "For CentOS/RHEL: sudo yum install jq"
    echo "For macOS (using Homebrew): brew install jq"
    exit 1
fi

if ! command -v _init_completion > /dev/null 2>&1; then
    # shellcheck disable=SC1091
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    else
        echo "ERROR: Please ensure you have bash-completion installed and sourced."
        exit 1
    fi
fi

"$install_path" install

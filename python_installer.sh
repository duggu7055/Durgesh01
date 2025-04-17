#Author - Durgesh Sharma
#created on - 17/4/2025
#version - v1
#Reviewer - Pritam


#!/bin/bash

# Define installation directories and other variables
INSTALL_DIR="$HOME/python_versions"
PYTHON_VERSIONS=("3.9.0" "3.10.4" "3.11.2")  # Example Python versions to install
PYTHON_TARBALL_URL="https://www.python.org/ftp/python"  # Python tarball URL base
PACKAGE_MANAGER=$(which apt || which yum || which dnf)

# Function to install dependencies for Ubuntu
install_dependencies_ubuntu() {
    echo "Installing dependencies for Ubuntu..."
    sudo apt update
    sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git
}

# Function to install dependencies for CentOS/RHEL
install_dependencies_centos() {
    echo "Installing dependencies for CentOS/RHEL..."
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel \
    readline-devel sqlite-devel wget curl
}

# Function to install platform-specific dependencies
install_dependencies() {
    if [ -z "$PACKAGE_MANAGER" ]; then
        echo "No compatible package manager found. Please install dependencies manually."
        exit 1
    fi

    if [ "$PACKAGE_MANAGER" == "/usr/bin/apt" ]; then
        install_dependencies_ubuntu
    elif [ "$PACKAGE_MANAGER" == "yum" ] || [ "$PACKAGE_MANAGER" == "dnf" ]; then
        install_dependencies_centos
    else
        echo "Unsupported package manager. Exiting..."
        exit 1
    fi
}

# Function to install Python from tarball
install_python_from_tarball() {
    VERSION=$1
    URL="$PYTHON_TARBALL_URL/$VERSION/Python-$VERSION.tgz"

    echo "Downloading Python $VERSION..."
    wget $URL -O Python-$VERSION.tgz

    echo "Extracting Python $VERSION..."
    tar -xzf Python-$VERSION.tgz

    cd Python-$VERSION

    echo "Configuring Python $VERSION..."
    ./configure --prefix=$INSTALL_DIR/python-$VERSION

    echo "Compiling Python $VERSION..."
    make -j$(nproc)

    echo "Installing Python $VERSION..."
    sudo make altinstall

    cd ..
    rm -rf Python-$VERSION
    rm Python-$VERSION.tgz
}

# Function to install specified Python versions
install_python_versions() {
    install_dependencies
    for version in "${PYTHON_VERSIONS[@]}"; do
        if ! command -v python$version &>/dev/null; then
            echo "Python $version not found, installing..."
            install_python_from_tarball $version
        else
            echo "Python $version is already installed."
        fi
    done
}

# Function to upgrade Python versions
upgrade_python() {
    VERSION=$1
    echo "Upgrading Python $VERSION..."
    cd $INSTALL_DIR
    rm -rf python-$VERSION
    install_python_from_tarball $VERSION
}

# Function to delete all installed Python versions
delete_all_python_versions() {
    read -p "Are you sure you want to delete all installed Python versions? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo "Deleting all installed Python versions..."
        sudo rm -rf "$INSTALL_DIR"
        echo "All installed Python versions have been removed."
    else
        echo "Deletion aborted."
    fi
}

# Function to delete a specific Python version
delete_specific_version() {
    local version=$1
    read -p "Are you sure you want to delete Python version $version? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo "Deleting Python version $version..."
        sudo rm -rf "$INSTALL_DIR/python-$version"
        echo "Python version $version has been removed."
    else
        echo "Deletion aborted."
    fi
}

# Main script options
# Handle script arguments
if [ $# -eq 0 ]; then
    # No arguments passed, install all versions
    install_python_versions
else
    case "$1" in
        -v)
            echo "Available Python versions:"
            for version in "${PYTHON_VERSIONS[@]}"; do
                echo "- Python $version"
            done
            ;;
        -u)
            install_dependencies
            echo "Checking for upgrades..."
            for version in "${PYTHON_VERSIONS[@]}"; do
                if command -v python$version &>/dev/null; then
                    read -p "Do you want to upgrade Python $version to the latest in the list? (y/n): " upgrade_choice
                    if [[ "$upgrade_choice" == "y" ]]; then
                        latest_version="${PYTHON_VERSIONS[-1]}"
                        upgrade_python $latest_version
                    else
                        echo "Upgrade skipped for Python $version."
                    fi
                fi
            done
            ;;
        -i)
            read -p "Enter the Python version you want to install (e.g., 3.10.4): " custom_version
            if [ -z "$custom_version" ]; then
                echo "No version entered. Aborting."
                exit 1
            fi
            if command -v python$custom_version &>/dev/null; then
                echo "Python $custom_version is already installed."
            else
                install_dependencies
                install_python_from_tarball "$custom_version"
            fi
            ;;
        -d)
            delete_all_python_versions
            ;;
        -d[0-9]*)
            version_to_delete="${1:2}"
            delete_specific_version $version_to_delete
            ;;
        *)
            echo "Invalid option. Usage:"
            echo "./python_installer.sh               # Install all versions"
            echo "./python_installer.sh -v            # Show available Python versions"
            echo "./python_installer.sh -u            # Upgrade to the latest version"
            echo "./python_installer.sh -i            # Install a specific version"
            echo "./python_installer.sh -d            # Delete all installed versions"
            echo "./python_installer.sh -d[version]   # Delete a specific version"
            exit 1
            ;;
    esac
fi

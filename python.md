
# Python Installation Script

## **Author Information**
| **Created**       | **Version** | **Last Modified** | **Author**        | **Level**            | **Reviewer**  |
|--------------------|-------------|-------------------|-------------------|------------------------|---------------|
| 17-04-2025         |           |         | Durgesh Sharma    | Internal review        | Pritam        |
|  17-04-2025          |          |         | Durgesh Sharma      | L0 Review | Shreya Jaiswal        |



## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
  - [Step 1: Create the Script File](#step-1-create-the-script-file)
  - [Step 2: Grant Execution Permission](#step-2-grant-execution-permission)
  - [Step 3: Execute the Script](#step-3-execute-the-script)
- [Conclusion](#conclusion)
- [Contact](#contact)
- [Reference](#reference)

---

## Introduction
This script provides an automated way to install or update Python on a Linux system. It downloads the desired Python version, compiles it from source, and configures the environment for immediate use. This ensures that you always have the latest or your specified version of Python installed efficiently.

---

## Installation

### Step 1: Create the Script File

1. Create a new file named `python_install.sh`.

 `python_install.sh`.


```bash
#!/bin/bash

# This script installs or updates the Python programming language on a Linux system.
# It fetches the desired Python version, compiles it from source, and configures the environment.

# Exit immediately if a command exits with a non-zero status
set -e

# Installation directory for Python
INSTALL_DIR="/usr/local/python"

# Function to ensure wget and build dependencies are installed
check_and_install_dependencies() {
  echo "Checking for required tools and installing dependencies..."

  if ! command -v wget &>/dev/null; then
    echo "wget not found, installing..."
    if [ -f /etc/redhat-release ]; then
      sudo yum install wget gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel -y
    elif [ -f /etc/debian_version ]; then
      sudo apt update && sudo apt install wget build-essential zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev xz-utils -y
    else
      echo "Unsupported OS. Please install dependencies manually."
      exit 1
    fi
  fi
}

# Function to fetch the latest Python version from the official source
get_latest_python_version() {
  curl -s https://www.python.org/ftp/python/ | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1
}

# Determine the version of Python to install
if [[ "$1" == "-v" ]]; then
  echo "Available Python versions:"
  curl -s https://www.python.org/ftp/python/ | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V
  exit 0
elif [ -z "$1" ]; then
  echo "No Python version provided. Fetching the latest stable version..."
  PYTHON_VERSION=$(get_latest_python_version)
else
  PYTHON_VERSION="$1"
fi

# Define the Python tarball and download URL
PYTHON_ARCHIVE="Python-${PYTHON_VERSION}.tgz"
DOWNLOAD_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_ARCHIVE}"

# Function to check if Python is already installed
check_python_installed() {
  if command -v python${PYTHON_VERSION%.*} >/dev/null 2>&1; then
    echo "Python version $(python${PYTHON_VERSION%.*} --version) is already installed."
    exit 0
  else
    echo "Python $PYTHON_VERSION is not installed."
  fi
}

# Function to remove any existing Python installation
remove_old_python() {
  echo "Removing previous Python installation..."
  sudo rm -rf "$INSTALL_DIR"
}

# Function to download and install the specified Python version
install_python() {
  echo "Downloading Python $PYTHON_VERSION..."
  wget -q --show-progress "$DOWNLOAD_URL" -O "/tmp/${PYTHON_ARCHIVE}"

  echo "Extracting Python archive..."
  tar -xzf "/tmp/${PYTHON_ARCHIVE}" -C /tmp

  echo "Building and installing Python $PYTHON_VERSION..."
  cd "/tmp/Python-${PYTHON_VERSION}"
  ./configure --prefix="$INSTALL_DIR"
  make -j$(nproc)
  sudo make altinstall

  echo "Python $PYTHON_VERSION installed at $INSTALL_DIR."
}

# Function to configure the Python environment
configure_env() {
  echo "Configuring Python environment..."
  PYTHON_BIN="$INSTALL_DIR/bin"
  PYTHON_ENV_LINE="export PATH=\$PATH:$PYTHON_BIN"

  # Add Python to the PATH if not already present
  if ! grep -q "$PYTHON_ENV_LINE" ~/.bashrc; then
    echo "$PYTHON_ENV_LINE" >> ~/.bashrc
  fi

  # Update the PATH for the current session
  export PATH=$PATH:$PYTHON_BIN

  echo "PATH updated. Python is now available in the terminal."
}

# Function to create symlinks for easy access to python3 and python
create_symlinks() {
  echo "Creating symbolic links for python3 and python..."

  # Remove existing symlinks if they exist
  sudo rm -f /usr/local/bin/python3
  sudo rm -f /usr/local/bin/python

  # Create new symlinks pointing to the installed version
  sudo ln -s /usr/local/python/bin/python${PYTHON_VERSION%.*} /usr/local/bin/python3
  sudo ln -s /usr/local/python/bin/python${PYTHON_VERSION%.*} /usr/local/bin/python

  echo "Symlinks created for python3 and python."
}

# Main script execution
check_and_install_dependencies  # Ensure dependencies are installed
check_python_installed          # Check if Python is already installed
remove_old_python               # Remove any previous Python installation
install_python                  # Download and install the desired Python version
configure_env                   # Set up the Python environment
create_symlinks                 # Create symlinks for python3 and python

# Print completion message with the installed Python version
echo "Python $PYTHON_VERSION installation completed!"
python3 --version
```

### Step 2: Grant Execution Permission
Run the following command to make the script executable:

```bash
chmod +x python_install.sh
```

### Step 3: Execute the Script
Run the script with the desired Python version as an argument (optional):

```bash
./python_install.sh 3.10.4
```

To list all available Python versions, run:

```bash
./python_install.sh -v
```
If no version is provided, the script installs the latest stable version by default.

To check the install python version, run:

```bash
python3 --version
```



---

## Conclusion
This script simplifies the process of installing and managing Python versions on Linux. It ensures that all dependencies are met, Python is built from source, and the environment is configured for immediate use.

---

## **Contact** 
| **Name**           | **Email Address**                                 |
|----------------|-----------------------------------------------|
| Durgesh Sharma | durgesh.sharma.snaatak@mygurukulam.co         |

---

## Reference

| Reference Link                          | Description               |
|----------------------------------------|---------------------------|
| [Official Python Downloads](https://www.python.org/ftp/python/) | Python source download page |



# Go Installation Script

Golang, or Go, is an open-source language known for its speed and scalability, widely used for high-performance server-side and cloud applications.


---


  <img src="https://go.dev/blog/go-brand/Go-Logo/PNG/Go-Logo_Yellow.png" alt="logo" width="400" height="300">



---




## **Author Information**
| **Created**       | **Version** | **Last Modified** | **Author**        | **Level**            | **Reviewer**  |
|--------------------|-------------|-------------------|-------------------|------------------------|---------------|
| 17-04-2025         |           |         | Durgesh Sharma    | Internal review        | Pritam        |
|  17-04-2025          |          |         | Durgesh Sharma      | L0 Review | Shreya Jaiswal        |

---
## Table of Contents
1. [Introduction](#introduction)
2. [Key Features](#key-features)
3. [Installation](#installation)
4. [Conclusion](#conclusion)
5. [Contact](#contact)
6. [References](#references)


## Introduction
This repository contains a bash script designed to simplify the process of installing and managing multiple versions of Golang on various Linux distributions. The script ensures compatibility across major operating systems and automates the configuration of your Go environment. 

## Key Features
| **Feature**                                      | **Description**                                                                      |
|--------------------------------------------------|--------------------------------------------------------------------------------------|
| **Install Any Version**                         | Install any version of Golang, including the latest stable release.                 |
| **Environment Configuration**                   | Automatically configures the environment to make Go readily available.              |
| **Clean Setup**                                 | Removes old installations to ensure a clean setup.                                  |
| **Multi-Distribution Support**                  | Supports multiple Linux distributions like Debian, Ubuntu, RHEL, CentOS, Fedora, Rocky, and AlmaLinux. |


## Installation
Below are the steps to manage the bash script used for installing and managing Golang:

### 1.Make a file: install_golang.sh
### install_golang.sh:
```bash
#!/bin/bash


set -e   

GO_DIR="/usr/local/go"

# Function to check if wget is installed
check_and_install_wget() {
  if ! command -v wget &>/dev/null; then
    echo "❌ wget not found, installing..."
    if [ -f /etc/redhat-release ]; then
      # For RHEL/CentOS/Fedora/AlmaLinux
      sudo yum install wget -y
    elif [ -f /etc/debian_version ]; then
      # For Debian/Ubuntu
      sudo apt update && sudo apt install wget -y
    else
      echo "❌ Unsupported OS. Please install wget manually."
      exit 1
    fi
  fi
}

# Function to get the latest stable Go version
get_latest_go_version() {
  curl -s https://go.dev/VERSION?m=text | grep -oE 'go[0-9]+\.[0-9]+(\.[0-9]+)?'
}

# Determine version to install
if [ -z "$1" ]; then
  echo "ℹ  No Go version provided. Fetching latest stable version..."
  GO_TAG=$(get_latest_go_version)
  GO_VERSION="${GO_TAG//go/}"
else
  GO_VERSION="$1"
fi

GO_ARCHIVE="go${GO_VERSION}.linux-amd64.tar.gz"
DOWNLOAD_URL="https://dl.google.com/go/${GO_ARCHIVE}"

# Function to check if Go is installed
check_go_installed() {
  if command -v go >/dev/null 2>&1; then
    echo "➡  Go version $(go version) is already installed"
  else
    echo "❌ Go is not installed"
  fi
}

# Function to remove previous Go installation
remove_old_go() {
  echo "🔁 Removing previous Go installation..."
  sudo rm -rf "$GO_DIR"
}

# Function to download and install Go
install_go() {
  echo "⬇  Downloading Go $GO_VERSION..."
  wget -q --show-progress "$DOWNLOAD_URL" -O "/tmp/${GO_ARCHIVE}"

  echo "📦 Extracting Go archive..."
  sudo tar -C /usr/local -xzf "/tmp/${GO_ARCHIVE}"

  echo "✅ Go $GO_VERSION installed at /usr/local/go"
}

# Function to configure Go environment
configure_env() {
  echo "⚙  Configuring Go environment..."
  GO_ENV_LINE='export PATH=$PATH:/usr/local/go/bin'

  if ! grep -q "$GO_ENV_LINE" ~/.bashrc; then
    echo "$GO_ENV_LINE" >> ~/.bashrc
  fi

  export PATH=$PATH:/usr/local/go/bin

  echo "🧠 PATH updated. Go is now available in the terminal."
}

# Main execution
check_go_installed
remove_old_go
install_go
configure_env

echo "🎉 Golang $GO_VERSION installation completed!"
go version
```
### 2. Make the script executable:

   ```bash
   chmod +x install_golang.sh
   ```

### 2. Run the script with the desired version:

   ```bash
   ./install_golang.sh <version>
   ```


## Conclusion
This bash script simplifies the installation and management of Golang on Linux systems. It automates the process, saving time and ensuring consistency, making it an efficient solution for both beginners and experienced developers.

---

## **Contact** 
| **Name**           | **Email Address**                                 |
|----------------|-----------------------------------------------|
| Durgesh Sharma | durgesh.sharma.snaatak@mygurukulam.co         |

---

## References
| **Description**                | **Link**                             |
|--------------------------------|-------------------------------------|
| Golang Official Documentation  | [Golang Docs](https://golang.org/doc/) |


# **Standard Operating Procedure (SOP) for Common Ubuntu Commands**

This document provides a comprehensive guide for frequently used Ubuntu commands, organized for easy reference.

---

## **Table of Contents**
1. [Objective](#objective)  
2. [Scope](#scope)  
3. [Prerequisites](#prerequisites)  
4. [Commands](#commands)  
    - [Basic System Commands](#1-basic-system-commands)  
    - [File Commands](#2-file-commands)  
    - [Directory Commands](#3-directory-commands)  
    - [File Permission Commands](#4-file-permission-commands)  
    - [Process Management Commands](#5-process-management-commands)  
    - [Network Commands](#6-network-commands)  
    - [Disk Management](#7-disk-management)  
5. [Notes](#notes)

---

## **Objective**
Provide a clear and concise reference for common Ubuntu commands to ensure efficient and accurate system management. 
This document serves as a quick reference for beginners and experienced users.

---

## **Scope**
Applicable for users managing Ubuntu systems for personal, development, or server-related tasks. 
It includes commands for file operations, directory management, user permissions, process monitoring, and more.

---

## **Prerequisites**
- Access to a terminal on an Ubuntu system.
- Appropriate permissions for commands requiring `sudo`.

---

## **Commands**

### **1. Basic System Commands**
1. **Check Ubuntu Version**
   ```bash
   lsb_release -a
   ```
   Displays details about the current Ubuntu version.

2. **View Kernel Version**
   ```bash
   uname -r
   ```
   Displays the Linux kernel version.

3. **Update and Upgrade Packages**
   ```bash
   sudo apt update && sudo apt upgrade
   ```
   Updates package lists and installs available updates.

4. **Reboot System**
   ```bash
   sudo reboot
   ```
    Safely restarts the system, ensuring all running processes are terminated properly.

---

### **2. File Commands**
1. **Create an Empty File**
   ```bash
   touch filename
   ```

2. **View File Content**
   ```bash
   cat filename
   ```
   Displays the content of a file.

3. **Delete a File**
   ```bash
   rm filename
   ```

4. **Rename or Move a File**
   ```bash
   mv old_filename new_filename
   ```

---

### **3. Directory Commands**
1. **Create a New Directory**
   ```bash
   mkdir directory_name
   ```

2. **Remove an Empty Directory**
   ```bash
   rmdir directory_name
   ```

3. **Delete a Directory with Files**
   ```bash
   rm -r directory_name
   ```

4. **List Contents of a Directory**
   ```bash
   ls -la
   ```
   Displays files, directories, and permissions in detailed format.

---

### **4. File Permission Commands**
1. **View File Permissions**
   ```bash
   ls -l filename
   ```

2. **Change File Permissions**
   ```bash
   chmod 755 filename
   ```

3. **Change Ownership of a File**
   ```bash
   sudo chown user:group filename
   ```

4. **Add Write Permission for All Users**
   ```bash
   chmod a+w filename
   ```

---

### **5. Process Management Commands**
1. **List Running Processes**
   ```bash
   ps aux
   ```

2. **Kill a Process**
   ```bash
   kill PID
   ```
   Replaces `PID` with the Process ID.

3. **Force Kill a Process**
   ```bash
   kill -9 PID
   ```

4. **Monitor System Processes**
   ```bash
   top
   ```

5. **Search for a Specific Process**
   ```bash
   pgrep process_name
   ```

6. **Check Resource Usage by Process**
   ```bash
   htop
   ```

---

### **6. Network Commands**
1. **Ping a Server**
   ```bash
   ping example.com
   ```

2. **Check Open Ports**
   ```bash
   sudo netstat -tuln
   ```

3. **Traceroute**
   ```bash
   traceroute example.com
   ```

---

### **7. Disk Management**
1. **Check Disk Usage**
   ```bash
   df -h
   ```

2. **View Free Memory**
   ```bash
   free -h
   ```

3. **List Partitions**
   ```bash
   lsblk
   ```

---

## **Notes**
- Always double-check commands involving `sudo` to avoid unintentional changes.
- Refer to the `man` command (e.g., `man ls`) for detailed usage instructions.
- For troubleshooting, consult the [Ubuntu Documentation](https://help.ubuntu.com/).

---
## **Reference Table**

| Other Commands                    | Link        |
| :--------                         | :------------------ |
| `Comprehensive Command List`      | https://www.digitalocean.com/community/tutorials/linux-commands |


## Author

- [@Durgeshsharma07](https://https://github.com/dashboard/tree/main)


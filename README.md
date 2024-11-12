# NVIDIA Driver Installation Tool for Kali Linux

This tool is a shell script designed to streamline the installation of NVIDIA GPU drivers on Kali Linux. It guides users through updating the system, disabling `nouveau` drivers, installing necessary kernel headers, and configuring Optimus for GDM. This tool also includes CUDA Toolkit and Hashcat installations, allowing users to fully utilize GPU acceleration for security testing and hash cracking.

## Features
1. **Initial Setup**: 
   - Updates Kali Linux
   - Installs kernel headers
   - Disables `nouveau` drivers and prompts for a reboot

2. **NVIDIA Driver Installation & Configuration**:
   - Installs NVIDIA GPU drivers from the Kali repository
   - Sets up Optimus configuration for GDM
   - Installs CUDA Toolkit and Hashcat with NVIDIA GPU support
   - Verifies driver installation and GPU information

## Usage
Simply run the script and select from the menu to complete either the initial setup or NVIDIA driver installation and configuration. Ideal for cybersecurity professionals and enthusiasts working on GPU-accelerated tasks in Kali Linux.

`sudo chmod 755 nvidia-installer.sh`
`sudo bash nvidia-installer.sh`


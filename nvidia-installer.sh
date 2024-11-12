#!/bin/bash

# Function to check for root privileges
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root" >&2
        exit 1
    fi
}

# Step 1: Update Kali Linux
update_kali() {
    echo "Updating Kali Linux..."
    apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
}

# Step 2: Install Kernel Headers
install_kernel_headers() {
    echo "Installing Kernel Headers..."
    apt install -y linux-headers-$(uname -r)
}

# Step 3: Disable nouveau
disable_nouveau() {
    echo "Disabling nouveau..."
    echo -e "blacklist nouveau\noptions nouveau modeset=0\nalias nouveau off" > /etc/modprobe.d/blacklist-nouveau.conf
    update-initramfs -u
    echo "Reboot required to disable nouveau. Please reboot and re-run this script to continue."
    exit 0
}

# Step 4: Verify if nouveau is disabled
verify_nouveau_disabled() {
    echo "Verifying if nouveau is disabled..."
    lsmod | grep -i nouveau && echo "nouveau is still enabled. Check blacklist configuration." || echo "nouveau is disabled."
}

# Step 5: Install NVIDIA Driver
install_nvidia_driver() {
    echo "Installing NVIDIA Driver..."
    apt-get install -y nvidia-driver nvidia-xconfig
}

# Step 6: Configure NVIDIA GPU with xconfig
configure_nvidia_xconfig() {
    echo "Configuring NVIDIA GPU..."
    nvidia-xconfig --query-gpu-info | grep 'BusID : ' | cut -d ' ' -f6 > /tmp/busid.txt
    BUS_ID=$(cat /tmp/busid.txt)
    echo "BusID for NVIDIA card: $BUS_ID"
}

# Step 7: Setting up Optimus Configuration for GDM Display Manager
setup_optimus_config() {
    echo "Setting up Optimus configuration..."
    echo -e "[Desktop Entry]\nType=Application\nName=Optimus\nExec=sh -c \"xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto\"\nNoDisplay=true\nX-GNOME-Autostart-Phase=DisplayServer" > /usr/share/gdm/greeter/autostart/optimus.desktop
    cp /usr/share/gdm/greeter/autostart/optimus.desktop /etc/xdg/autostart/optimus.desktop
}

# Step 8: Finalizing NVIDIA Driver Installation
finalize_installation() {
    echo "Finalizing NVIDIA Driver installation..."
    glxinfo | grep -i "direct rendering"
}

# Step 9: Install CUDA Toolkit
install_cuda_toolkit() {
    echo "Installing NVIDIA CUDA Toolkit..."
    apt-get install -y ocl-icd-libopencl1 nvidia-cuda-toolkit
}

# Step 10: Install Hashcat with NVIDIA support
install_hashcat_nvidia() {
    echo "Installing hashcat with NVIDIA support..."
    apt install -y ocl-icd-libopencl1 nvidia-driver hashcat-nvidia
}

# Step 11: Verify Driver Installation
verify_driver_installation() {
    echo "Verifying NVIDIA Driver installation..."
    nvidia-smi
}

# Step 12: Query GPU Information
query_gpu_info() {
    echo "Querying GPU Information..."
    nvidia-smi -i 0 -q
}

# Step 13: Install Hashcat and Verify CUDA with Hashcat
install_hashcat_verify_cuda() {
    echo "Installing Hashcat and verifying CUDA support..."
    apt install -y hashcat
    hashcat -I
    hashcat -b | uniq
}

# Menu function
menu() {
    echo "Select an option to proceed:"
    echo "1) Initial Setup (Update, Kernel Headers, Disable nouveau)"
    echo "2) NVIDIA Driver Installation and Configuration"
    echo "3) Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1)
            update_kali
            install_kernel_headers
            disable_nouveau
            ;;
        2)
            verify_nouveau_disabled
            install_nvidia_driver
            configure_nvidia_xconfig
            setup_optimus_config
            finalize_installation
            install_cuda_toolkit
            install_hashcat_nvidia
            verify_driver_installation
            query_gpu_info
            install_hashcat_verify_cuda
            echo "NVIDIA Driver and CUDA Toolkit installation completed successfully."
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select 1, 2, or 3."
            menu
            ;;
    esac
}

# Main script execution
check_root
menu

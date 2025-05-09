#!/bin/bash

# S23 Vulkan Graphics Enabler for Linux
# Enables Vulkan graphics API on Samsung S23 series devices

# Terminal colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SIMPLE_MODE=0
LOGGING=0
LOG_FILE="$SCRIPT_DIR/vulkanize.log"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --simple)
            SIMPLE_MODE=1
            ;;
        --log)
            LOGGING=1
            ;;
        --normal)
            MODE="normal"
            AUTO_MODE=1
            ;;
        --aggressive)
            MODE="aggressive"
            AUTO_MODE=1
            ;;
        --help)
            echo "S23 Vulkan Graphics Enabler for Linux"
            echo "Usage: ./vulkan-enabler.sh [OPTIONS]"
            echo
            echo "Options:"
            echo "  --simple     : Run in simple mode with fewer prompts"
            echo "  --log        : Enable detailed logging"
            echo "  --normal     : Enable Vulkan in normal mode and exit"
            echo "  --aggressive : Enable Vulkan in aggressive mode and exit"
            echo "  --help       : Show this help information"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
    shift
done

# Initialize log if enabled
if [ $LOGGING -eq 1 ]; then
    echo "Logging enabled. Log will be saved to: $LOG_FILE"
    echo "Starting log at $(date)" > "$LOG_FILE"
fi

# Clear screen function
clear_screen() {
    clear
}

# Check if ADB is installed
check_adb() {
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}ADB not found!${NC}"
        echo "Would you like to install it now? (y/n)"
        read -r install_choice
        if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
            # Detect distribution and package manager
            PKG_MANAGER=""
            PKG_NAME=""
            
            if command -v apt &> /dev/null; then
                echo "Detected Debian/Ubuntu-based distribution"
                PKG_MANAGER="apt"
                PKG_NAME="android-sdk-platform-tools"
                INSTALL_CMD="sudo apt-get update && sudo apt-get install -y"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Detected Debian/Ubuntu-based distribution" >> "$LOG_FILE"
                fi
            elif command -v dnf &> /dev/null; then
                echo "Detected Fedora/RHEL-based distribution"
                PKG_MANAGER="dnf"
                PKG_NAME="android-tools"
                INSTALL_CMD="sudo dnf install -y"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Detected Fedora/RHEL-based distribution" >> "$LOG_FILE"
                fi
            elif command -v pacman &> /dev/null; then
                echo "Detected Arch-based distribution"
                PKG_MANAGER="pacman"
                PKG_NAME="android-tools"
                INSTALL_CMD="sudo pacman -S --noconfirm"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Detected Arch-based distribution" >> "$LOG_FILE"
                fi
            elif command -v zypper &> /dev/null; then
                echo "Detected openSUSE distribution"
                PKG_MANAGER="zypper"
                PKG_NAME="android-tools"
                INSTALL_CMD="sudo zypper install -y"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Detected openSUSE distribution" >> "$LOG_FILE"
                fi
            elif command -v emerge &> /dev/null; then
                echo "Detected Gentoo distribution"
                PKG_MANAGER="emerge"
                PKG_NAME="dev-util/android-tools"
                INSTALL_CMD="sudo emerge"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Detected Gentoo distribution" >> "$LOG_FILE"
                fi
            fi
            
            # Install ADB if package manager detected
            if [ -n "$PKG_MANAGER" ]; then
                echo "Installing ADB using $PKG_MANAGER..."
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Installing ADB via $PKG_MANAGER ($PKG_NAME)" >> "$LOG_FILE"
                fi
                
                # Execute the installation command
                INSTALL_OUTPUT=$($INSTALL_CMD $PKG_NAME 2>&1)
                INSTALL_STATUS=$?
                
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Installation command output:" >> "$LOG_FILE"
                    echo "$INSTALL_OUTPUT" >> "$LOG_FILE"
                fi
                
                # Check if installation was successful
                if [ $INSTALL_STATUS -ne 0 ] || ! command -v adb &> /dev/null; then
                    echo -e "${RED}Failed to install ADB automatically.${NC}"
                    echo "$INSTALL_OUTPUT" | grep -i "error"
                    echo
                    echo "Would you like to try the manual installation method? (y/n)"
                    read -r manual_install
                    if [[ $manual_install == "y" || $manual_install == "Y" ]]; then
                        echo -e "${YELLOW}Manual installation instructions:${NC}"
                        echo
                        echo "1. Download Android SDK Platform Tools from:"
                        echo "   https://developer.android.com/studio/releases/platform-tools"
                        echo
                        echo "2. Extract the ZIP file to a location of your choice"
                        echo
                        echo "3. Add platform-tools to your PATH by running:"
                        echo "   echo 'export PATH=\$PATH:/path/to/platform-tools' >> ~/.$(basename $SHELL)rc"
                        echo "   source ~/.$(basename $SHELL)rc"
                        echo
                        echo "4. Run this script again after installation"
                        
                        if [ $LOGGING -eq 1 ]; then
                            echo "[$(date)] Provided manual installation instructions" >> "$LOG_FILE"
                        fi
                        exit 1
                    else
                        echo "Exiting script. Please install ADB and try again."
                        if [ $LOGGING -eq 1 ]; then
                            echo "[$(date)] User declined manual installation. Exiting." >> "$LOG_FILE"
                        fi
                        exit 1
                    fi
                else
                    echo -e "${GREEN}ADB installed successfully!${NC}"
                    adb version
                    if [ $LOGGING -eq 1 ]; then
                        echo "[$(date)] ADB installed successfully" >> "$LOG_FILE"
                        adb version >> "$LOG_FILE"
                    fi
                fi
            else
                echo -e "${YELLOW}Could not automatically detect your distribution.${NC}"
                echo "Would you like to try these common installation commands? (y/n)"
                read -r try_common
                if [[ $try_common == "y" || $try_common == "Y" ]]; then
                    echo "Trying common installation methods..."
                    if [ $LOGGING -eq 1 ]; then
                        echo "[$(date)] Trying common installation methods" >> "$LOG_FILE"
                    fi
                    
                    # Try apt-get first (most common)
                    if sudo apt-get update && sudo apt-get install -y android-sdk-platform-tools; then
                        echo -e "${GREEN}ADB installed successfully with apt-get!${NC}"
                        if [ $LOGGING -eq 1 ]; then
                            echo "[$(date)] ADB installed successfully with apt-get" >> "$LOG_FILE"
                        fi
                    # Try snap as a fallback
                    elif command -v snap &> /dev/null && sudo snap install androidsdk; then
                        echo -e "${GREEN}Android SDK installed successfully with snap!${NC}"
                        echo "You may need to restart your terminal or run: export PATH=\$PATH:/snap/androidsdk/current/platform-tools"
                        export PATH=$PATH:/snap/androidsdk/current/platform-tools
                        if [ $LOGGING -eq 1 ]; then
                            echo "[$(date)] Android SDK installed successfully with snap" >> "$LOG_FILE"
                        fi
                    else
                        echo -e "${RED}Automatic installation failed.${NC}"
                        echo "Please install ADB manually:"
                        echo "For Debian/Ubuntu: sudo apt-get update && sudo apt-get install android-sdk-platform-tools"
                        echo "For Fedora/RHEL: sudo dnf install android-tools"
                        echo "For Arch: sudo pacman -S android-tools"
                        echo "For openSUSE: sudo zypper install android-tools"
                        echo "For other distributions: download from https://developer.android.com/studio/releases/platform-tools"
                        if [ $LOGGING -eq 1 ]; then
                            echo "[$(date)] Automatic installation failed. Suggested manual installation." >> "$LOG_FILE"
                        fi
                        exit 1
                    fi
                else
                    echo "Please install ADB manually:"
                    echo "For Debian/Ubuntu: sudo apt-get update && sudo apt-get install android-sdk-platform-tools"
                    echo "For Fedora/RHEL: sudo dnf install android-tools"
                    echo "For Arch: sudo pacman -S android-tools"
                    echo "For openSUSE: sudo zypper install android-tools"
                    echo "For other distributions: download from https://developer.android.com/studio/releases/platform-tools"
                    if [ $LOGGING -eq 1 ]; then
                        echo "[$(date)] User declined automatic installation attempt. Exiting." >> "$LOG_FILE"
                    fi
                    exit 1
                fi
            fi
        else
            echo "Please install ADB manually and try again."
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] ADB installation declined. Exiting." >> "$LOG_FILE"
            fi
            exit 1
        fi
    fi
    echo -e "${GREEN}ADB is installed.${NC}"
    # Display ADB version for verification
    ADB_VERSION=$(adb version)
    echo "$ADB_VERSION"
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] ADB is installed" >> "$LOG_FILE"
        echo "$ADB_VERSION" >> "$LOG_FILE"
    fi
}

# Check device connection
check_device() {
    echo "Checking for connected devices..."
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Checking for connected devices" >> "$LOG_FILE"
        adb devices >> "$LOG_FILE"
    fi
    
    # Check if user has access to ADB devices (udev rules)
    if ! adb devices 2>&1 | grep -q "List of devices" && adb devices 2>&1 | grep -iq "permission"; then
        echo -e "${RED}ADB device access permission denied.${NC}"
        echo "This is usually due to missing udev rules for Android devices."
        echo
        echo "Would you like to fix this by adding udev rules? (y/n)"
        read -r fix_udev
        if [[ $fix_udev == "y" || $fix_udev == "Y" ]]; then
            echo "Creating udev rules for Android devices..."
            
            UDEV_RULE='SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"'
            
            echo "Adding current user to plugdev group..."
            if sudo usermod -aG plugdev $USER; then
                echo "User added to plugdev group successfully."
            else
                echo "Failed to add user to plugdev group."
            fi
            
            echo "Creating udev rules for Android devices..."
            if echo "$UDEV_RULE" | sudo tee /etc/udev/rules.d/51-android.rules > /dev/null && \
               sudo chmod a+r /etc/udev/rules.d/51-android.rules && \
               sudo udevadm control --reload-rules && \
               sudo udevadm trigger; then
                echo -e "${GREEN}Udev rules created successfully.${NC}"
                echo "Please disconnect and reconnect your device,"
                echo "then restart this script (you may need to log out and back in first)."
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Created udev rules for Android devices" >> "$LOG_FILE"
                fi
                exit 0
            else
                echo -e "${RED}Failed to create udev rules.${NC}"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Failed to create udev rules" >> "$LOG_FILE"
                fi
            fi
        fi
    fi
    
    # Check ADB server status and start if needed
    adb start-server
    
    # Get list of connected devices
    devices=$(adb devices | grep -v "List" | grep -v "^$")
    
    if [ -z "$devices" ]; then
        echo -e "${RED}No device found.${NC}"
        echo "Please ensure:"
        echo " - The device is connected via USB"
        echo " - USB debugging is enabled on your phone:"
        echo "   Settings > Developer options > USB debugging"
        echo " - You have proper USB access permissions in Linux"
        echo
        echo "Would you like to try restarting the ADB server? (y/n)"
        read -r restart_adb
        if [[ $restart_adb == "y" || $restart_adb == "Y" ]]; then
            echo "Restarting ADB server..."
            adb kill-server
            sleep 2
            adb start-server
            sleep 2
            
            # Check again after restart
            devices=$(adb devices | grep -v "List" | grep -v "^$")
            if [ -z "$devices" ]; then
                echo -e "${RED}Still no device found.${NC}"
                echo "Try these troubleshooting steps:"
                echo " 1. Disconnect and reconnect the USB cable"
                echo " 2. Try a different USB port (directly connect to PC, not through a hub)"
                echo " 3. On your phone, go to Developer options and revoke USB debugging authorizations"
                echo " 4. Toggle USB debugging off and on again"
                echo " 5. Try changing USB mode in the notification panel to 'File Transfer' or 'MIDI'"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] No device found after ADB server restart" >> "$LOG_FILE"
                fi
                return 1
            else
                echo -e "${GREEN}Device found after restarting ADB server!${NC}"
                echo "$devices"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Device found after ADB server restart" >> "$LOG_FILE"
                    echo "$devices" >> "$LOG_FILE" 
                fi
            fi
        else
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] No device found, user declined server restart" >> "$LOG_FILE"
            fi
            return 1
        fi
    elif echo "$devices" | grep -q "unauthorized"; then
        echo -e "${YELLOW}Device connected but unauthorized.${NC}"
        echo "Please check your phone for a USB debugging authorization dialog."
        echo "If you don't see one, try disconnecting and reconnecting the USB cable."
        echo "Make sure to check 'Always allow from this computer' on the dialog."
        if [ $LOGGING -eq 1 ]; then
            echo "[$(date)] Device connected but unauthorized" >> "$LOG_FILE"
        fi
        return 1
    elif echo "$devices" | grep -q "device$"; then
        # Get device model for verification
        model=$(adb shell getprop ro.product.model 2>/dev/null)
        if [ -n "$model" ]; then
            echo -e "${GREEN}Device connected successfully: $model${NC}"
            
            # Check if it's an S23 series device
            if echo "$model" | grep -q -E "SM-S91|S23"; then
                echo -e "${GREEN}Detected Samsung S23 series device!${NC}"
            else
                echo -e "${YELLOW}Warning: This doesn't appear to be an S23 series device.${NC}"
                echo "This tool is designed specifically for Samsung S23 series."
                echo "Do you want to continue anyway? (y/n)"
                read -r non_s23_continue
                if [[ $non_s23_continue != "y" && $non_s23_continue != "Y" ]]; then
                    if [ $LOGGING -eq 1 ]; then
                        echo "[$(date)] Non-S23 device detected, user aborted" >> "$LOG_FILE"
                    fi
                    return 1
                fi
            fi
            
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] Device connected successfully: $model" >> "$LOG_FILE"
            fi
            return 0
        else
            echo -e "${YELLOW}Device connected but communication error.${NC}"
            echo "ADB may be connected but can't communicate properly with the device."
            echo "Try the following:"
            echo " - Check if the screen is unlocked"
            echo " - Try toggling USB debugging off and on"
            echo " - Make sure the device is not in recovery or fastboot mode"
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] Device connected but communication error" >> "$LOG_FILE"
            fi
            return 1
        fi
    else
        echo -e "${YELLOW}Device state unknown: ${NC}"
        echo "$devices"
        if [ $LOGGING -eq 1 ]; then
            echo "[$(date)] Device state unknown" >> "$LOG_FILE"
            echo "$devices" >> "$LOG_FILE"
        fi
        return 1
    fi
}

# Enable Vulkan function
enable_vulkan() {
    local mode=$1
    
    echo "Enabling Vulkan ($mode mode)..."
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Enabling Vulkan in $mode mode" >> "$LOG_FILE"
    fi
    
    echo "Setting HWUI renderer to skiavk..."
    adb shell setprop debug.hwui.renderer skiavk
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Set property debug.hwui.renderer to skiavk" >> "$LOG_FILE"
    fi
    
    echo "Forcing crash: System UI"
    adb shell am crash com.android.systemui
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Forced crash: System UI" >> "$LOG_FILE"
    fi
    
    echo "Forcing stop: Settings"
    adb shell am force-stop com.android.settings
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Forced stop: Settings" >> "$LOG_FILE"
    fi
    
    echo "Forcing stop: Samsung Launcher"
    adb shell am force-stop com.sec.android.app.launcher
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Forced stop: Samsung Launcher" >> "$LOG_FILE"
    fi
    
    echo "Forcing stop: AOD Service"
    adb shell am force-stop com.samsung.android.app.aodservice
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Forced stop: AOD Service" >> "$LOG_FILE"
    fi
    
    if [ "$mode" == "aggressive" ]; then
        echo "Checking for Gboard..."
        if adb shell pm list packages | grep -q "com.google.android.inputmethod.latin"; then
            echo "Forcing crash: Gboard"
            adb shell am crash com.google.android.inputmethod.latin
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] Forced crash: Gboard" >> "$LOG_FILE"
            fi
        else
            echo "Gboard not installed, skipping."
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] Gboard not installed, skipped" >> "$LOG_FILE"
            fi
        fi
    fi
    
    echo -e "${GREEN}Vulkan should now be enabled!${NC}"
    echo "Remember this setting will revert after a reboot."
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Vulkan enabling process completed" >> "$LOG_FILE"
    fi
}

# Display verification instructions
verification_info() {
    echo -e "${BOLD}=== VERIFICATION STEPS ===${NC}"
    echo
    echo "To verify Vulkan is enabled on your S23 device:"
    echo
    echo "Method 1: Using GPUWatch"
    echo " 1. On your phone, go to Settings > Developer Options"
    echo " 2. Scroll down and enable \"GPU watch\""
    echo " 3. Open any app (like the dialer or settings)"
    echo " 4. Look for \"Vulkan Renderer (skiavk)\" in the overlay"
    echo
    echo "Method 2: Using ADB (Technical)"
    echo " Run this command to check the current renderer:"
    echo " - adb shell getprop debug.hwui.renderer"
    echo " It should return: \"skiavk\""
    echo
    echo -e "${YELLOW}Troubleshooting:${NC}"
    echo "If Vulkan isn't enabled after running the script:"
    echo " 1. Try using the Aggressive mode"
    echo " 2. Restart your phone and run the script again"
    echo " 3. Check USB debugging is still enabled"
    echo " 4. Some apps may need to be restarted manually"
    echo
    echo "Would you like to check the current renderer value now? (y/n)"
    read -r check_renderer
    if [[ $check_renderer == "y" || $check_renderer == "Y" ]]; then
        renderer=$(adb shell getprop debug.hwui.renderer 2>/dev/null)
        if [ -n "$renderer" ]; then
            echo -e "Current renderer: ${BOLD}$renderer${NC}"
            if [ "$renderer" == "skiavk" ]; then
                echo -e "${GREEN}Vulkan is enabled!${NC}"
                
                # Get current GPU info to provide more details
                echo
                echo "Checking GPU information..."
                gpu_info=$(adb shell getprop ro.hardware.vulkan 2>/dev/null)
                
                if [ -n "$gpu_info" ]; then
                    echo -e "GPU: ${GREEN}$gpu_info${NC}"
                fi
                
                # Try to get more GPU performance details if possible
                echo
                echo "You can verify hardware acceleration is working by:"
                echo " 1. Looking for smooth UI animations"
                echo " 2. Opening GPU-heavy apps like games"
                echo " 3. Checking battery usage and temperature compared to before"
            else
                echo -e "${YELLOW}Vulkan is not enabled. Try running the enable function again.${NC}"
            fi
        else
            echo -e "${RED}Couldn't get renderer information. Is the device connected?${NC}"
        fi
    fi
    
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Verification instructions displayed" >> "$LOG_FILE"
        if [[ $check_renderer == "y" || $check_renderer == "Y" ]]; then
            echo "[$(date)] Current renderer: $renderer" >> "$LOG_FILE"
        fi
    fi
}

# Display help information
show_help() {
    echo -e "${BOLD}=== HELP & INFORMATION ===${NC}"
    echo
    echo -e "${GREEN}ABOUT THIS TOOL${NC}"
    echo "S23 Vulkan Graphics Enabler forces Samsung S23 series phones to use"
    echo "the Vulkan graphics API instead of the default OpenGL ES renderer."
    echo
    echo -e "${GREEN}BENEFITS${NC}"
    echo " ✓ Improved performance in games and graphical applications"
    echo " ✓ Reduced heat generation during intensive tasks"
    echo " ✓ Better battery life due to more efficient GPU usage"
    echo " ✓ Generally smoother user interface animations"
    echo
    echo -e "${YELLOW}IMPORTANT NOTES${NC}"
    echo " • The change is temporary and will revert after reboot"
    echo " • You must run this script again after every reboot"
    echo " • This tool is specifically designed for Samsung S23 series"
    echo " • While usable on other Samsung devices, results may vary"
    echo
    echo -e "${RED}KNOWN ISSUES${NC}"
    echo " • Potential visual artifacts in some applications"
    echo " • Some apps may crash or not run properly under Vulkan"
    echo " • Default browser and keyboard preferences may reset"
    echo " • Possible temporary loss of WiFi-Calling/VoLTE"
    echo "   (fix by toggling airplane mode or SIM in settings)"
    echo
    echo -e "${GREEN}NORMAL VS AGGRESSIVE MODE${NC}"
    echo " • Normal Mode: Restarts only essential system UI components"
    echo "   Preferred for daily use with minimal disruption"
    echo
    echo " • Aggressive Mode: Restarts more system components including Gboard"
    echo "   Use when Normal mode doesn't successfully enable Vulkan"
    echo
    echo -e "${GREEN}LINUX-SPECIFIC NOTES${NC}"
    echo " • ADB access requires proper udev rules on most distributions"
    echo " • If your device isn't detected, the script can add these rules"
    echo " • You may need to install additional USB drivers on some distros"
    echo " • If using a desktop environment, make sure it's not auto-mounting"
    echo "   the phone in a way that interferes with ADB"
    echo
    echo -e "${GREEN}COMMAND LINE OPTIONS${NC}"
    echo "  --simple     : Run in simple mode with fewer prompts"
    echo "  --log        : Enable detailed logging"
    echo "  --normal     : Enable Vulkan in normal mode and exit"
    echo "  --aggressive : Enable Vulkan in aggressive mode and exit"
    echo "  --help       : Show this help information"
    echo
    echo -e "${GREEN}SUPPORT${NC}"
    echo "For help, bug reports, or feature requests, visit:"
    echo "https://github.com/YOUR_USERNAME/vulkanize/issues"
    
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Help information displayed" >> "$LOG_FILE"
    fi
}

# Main menu
main_menu() {
    clear_screen
    echo "==================================================="
    echo "    S23 VULKAN GRAPHICS ENABLER - LINUX"
    echo "==================================================="
    echo
    echo " 1. Check device connection"
    echo " 2. Enable Vulkan (Normal mode - fewer app restarts)"
    echo " 3. Enable Vulkan (Aggressive mode - restart all apps)"
    echo " 4. Verify Vulkan status"
    echo " 5. Help and information"
    echo " 6. Exit"
    echo
    echo "==================================================="
    echo
    
    read -p "Enter your choice (1-6): " choice
    
    case $choice in
        1)
            clear_screen
            check_device
            if [ $SIMPLE_MODE -eq 0 ]; then
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            clear_screen
            if check_device; then
                enable_vulkan "normal"
                if [ $SIMPLE_MODE -eq 0 ]; then
                    read -p "Press Enter to continue..."
                fi
            else
                if [ $SIMPLE_MODE -eq 0 ]; then
                    read -p "Press Enter to continue..."
                fi
            fi
            ;;
        3)
            clear_screen
            if check_device; then
                enable_vulkan "aggressive"
                if [ $SIMPLE_MODE -eq 0 ]; then
                    read -p "Press Enter to continue..."
                fi
            else
                if [ $SIMPLE_MODE -eq 0 ]; then
                    read -p "Press Enter to continue..."
                fi
            fi
            ;;
        4)
            clear_screen
            verification_info
            if [ $SIMPLE_MODE -eq 0 ]; then
                read -p "Press Enter to continue..."
            fi
            ;;
        5)
            clear_screen
            show_help
            if [ $SIMPLE_MODE -eq 0 ]; then
                read -p "Press Enter to continue..."
            fi
            ;;
        6)
            echo "Thank you for using S23 Vulkan Graphics Enabler!"
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] Script execution ended" >> "$LOG_FILE"
            fi
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Invalid choice. Please try again.${NC}"
            sleep 2
            ;;
    esac
}

# Start the script
check_adb

# Check for auto mode
if [ -n "$AUTO_MODE" ]; then
    if check_device; then
        enable_vulkan "$MODE"
        echo "Thank you for using S23 Vulkan Graphics Enabler!"
        exit 0
    else
        echo "Cannot continue without a connected device."
        exit 1
    fi
fi

# Main loop
while true; do
    main_menu
done

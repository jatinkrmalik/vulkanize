#!/bin/bash

# S23 Vulkan Graphics Enabler for macOS
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
            echo "S23 Vulkan Graphics Enabler for macOS"
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
        echo "Would you like to install it using Homebrew? (y/n)"
        read -r install_choice
        if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
            if ! command -v brew &> /dev/null; then
                echo "Homebrew not found. Please install Homebrew first:"
                echo "Visit: https://brew.sh"
                if [ $LOGGING -eq 1 ]; then
                    echo "[$(date)] Homebrew not found. Installation aborted." >> "$LOG_FILE"
                fi
                exit 1
            fi
            echo "Installing ADB..."
            brew install android-platform-tools
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] Installing ADB via Homebrew" >> "$LOG_FILE"
            fi
            echo "ADB installed successfully!"
        else
            echo "Please install ADB manually and try again."
            echo "Visit: https://developer.android.com/studio/releases/platform-tools"
            if [ $LOGGING -eq 1 ]; then
                echo "[$(date)] ADB installation declined. Exiting." >> "$LOG_FILE"
            fi
            exit 1
        fi
    fi
    echo -e "${GREEN}ADB is installed.${NC}"
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] ADB is installed" >> "$LOG_FILE"
    fi
}

# Check device connection
check_device() {
    echo "Checking for connected devices..."
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Checking for connected devices" >> "$LOG_FILE"
        adb devices >> "$LOG_FILE"
    fi
    
    devices=$(adb devices | grep -v "List" | grep "device$")
    if [ -z "$devices" ]; then
        echo -e "${RED}No device found or not authorized.${NC}"
        echo "Please ensure:"
        echo " - USB debugging is enabled on your phone"
        echo " - The device is connected via USB"
        echo " - You've authorized the computer on your device"
        if [ $LOGGING -eq 1 ]; then
            echo "[$(date)] No device found or not authorized" >> "$LOG_FILE"
        fi
        return 1
    else
        echo -e "${GREEN}Device connected successfully!${NC}"
        echo "$devices"
        if [ $LOGGING -eq 1 ]; then
            echo "[$(date)] Device connected successfully" >> "$LOG_FILE"
        fi
        return 0
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
    echo "To verify Vulkan is enabled:"
    echo " 1. On your phone, go to Settings"
    echo " 2. Open Developer Options"
    echo " 3. Enable GPUWatch"
    echo " 4. Open any app (like the dialer)"
    echo " 5. Look for \"Vulkan Renderer (skiavk)\" in the overlay"
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Verification instructions displayed" >> "$LOG_FILE"
    fi
}

# Display help information
show_help() {
    echo -e "${BOLD}=== HELP & INFORMATION ===${NC}"
    echo
    echo "This tool forces Samsung S23 phones to use Vulkan graphics API instead of OpenGL."
    echo
    echo "Benefits:"
    echo " - Improved performance"
    echo " - Reduced heat"
    echo " - Better battery life"
    echo
    echo "Notes:"
    echo " - The change is temporary and will revert after reboot"
    echo " - You must run this script again after every reboot"
    echo " - Some apps may not work properly with Vulkan"
    echo
    echo "Known issues:"
    echo " - Potential visual artifacts in some apps"
    echo " - Some apps may not run under Vulkan"
    echo " - Default browser and keyboard may reset"
    echo " - Possible loss of WiFi-Calling/VoLTE (fix by toggling SIM in settings)"
    echo
    echo "Command line options:"
    echo "  --simple     : Run in simple mode with fewer prompts"
    echo "  --log        : Enable detailed logging"
    echo "  --normal     : Enable Vulkan in normal mode and exit"
    echo "  --aggressive : Enable Vulkan in aggressive mode and exit"
    echo "  --help       : Show this help information"
    if [ $LOGGING -eq 1 ]; then
        echo "[$(date)] Help information displayed" >> "$LOG_FILE"
    fi
}

# Main menu
main_menu() {
    clear_screen
    echo "==================================================="
    echo "    S23 VULKAN GRAPHICS ENABLER - macOS"
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

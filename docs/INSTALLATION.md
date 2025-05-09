# Detailed Installation Instructions

This document provides detailed instructions for installing and setting up Vulkanize on different operating systems.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Windows Installation](#windows-installation)
- [macOS Installation](#macos-installation)
- [Linux Installation](#linux-installation)
- [Manual ADB Installation](#manual-adb-installation)
- [Enabling USB Debugging](#enabling-usb-debugging)
- [Troubleshooting Installation Issues](#troubleshooting-installation-issues)

## Prerequisites

Before installing Vulkanize, ensure you have:

1. A Samsung S23, S23+, S23 Ultra, or S23 FE device
2. A USB cable compatible with your device
3. A computer running Windows, macOS, or Linux
4. USB debugging enabled on your device (instructions below)
5. Administrator/root access to your computer (for ADB installation)

## Windows Installation

### Method 1: Using the Installer (Recommended)

1. Download the latest Windows installer from the [Releases](https://github.com/jatinkrmalik/vulkanize/releases) page
2. Run the installer and follow the on-screen instructions
3. The installer will create a shortcut on your desktop and start menu
4. Connect your device via USB and run Vulkanize

### Method 2: Manual Installation

1. Download the latest ZIP archive for Windows from the [Releases](https://github.com/jatinkrmalik/vulkanize/releases) page
2. Extract the archive to a location of your choice
3. Connect your device via USB
4. Run the `vulkan-enabler.bat` file by double-clicking on it
5. The script will automatically check for ADB and use one of these methods:
   - Offer to download and install ADB directly from Google's official site
   - If automated download fails or is declined, provide detailed instructions for manual installation

#### Alternative Methods for ADB Installation

If the automatic download doesn't work, you have two simple options:

1. **Add platform-tools to PATH** (recommended for long-term use):
   - Download and extract platform-tools from Google's official site
   - Add the extracted folder to your system PATH
   - Run the script from any location

2. **Run the script from platform-tools folder** (simpler approach):
   - Download and extract platform-tools from Google's official site
   - Copy `vulkan-enabler.bat` to the extracted platform-tools folder
   - Run the script directly from there

Both methods are explained in detail within the script itself.

## macOS Installation

### Method 1: Using Homebrew

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Tap the Vulkanize repository
brew tap jatinkrmalik/vulkanize

# Install Vulkanize
brew install vulkanize

# Run Vulkanize
vulkanize
```

### Method 2: Manual Installation

1. Download the latest macOS archive from the [Releases](https://github.com/jatinkrmalik/vulkanize/releases) page
2. Extract the archive to a location of your choice
3. Open Terminal and navigate to the extracted directory
4. Make the script executable:
   ```bash
   chmod +x scripts/mac/vulkan-enabler.sh
   ```
5. Run the script:
   ```bash
   ./scripts/mac/vulkan-enabler.sh
   ```
6. The script has enhanced capabilities to automatically install:
   - Homebrew (if not found) - the package manager for macOS
   - ADB (via Homebrew once installed)
   - Additionally, it can automatically configure PATH settings in your shell profile

### Automatic Environment Setup in macOS

The enhanced macOS script now provides:

1. **Fully Automated Homebrew Installation**:
   - Detects if Homebrew is missing and offers to install it
   - Automatically adds Homebrew to your PATH in the appropriate shell profile
   - Works with both zsh (default on newer macOS) and bash
   - Supports both Intel and Apple Silicon Macs

2. **Intelligent Shell Detection**:
   - Identifies which shell you're using (zsh or bash)
   - Modifies the correct configuration file (~/.zshrc or ~/.bash_profile)
   - No manual PATH configuration needed

3. **Enhanced ADB Installation**:
   - Better error handling if ADB installation fails
   - Provides troubleshooting steps for common issues
   - Verifies ADB works after installation

This means you can now run the script on a fresh macOS installation with minimal manual intervention.

## Linux Installation

### Method 1: Using Package Manager (Debian/Ubuntu)

```bash
# Add the Vulkanize repository
sudo add-apt-repository ppa:jatinkrmalik/vulkanize
sudo apt-get update

# Install Vulkanize
sudo apt-get install vulkanize

# Run Vulkanize
vulkanize
```

### Method 2: Manual Installation

1. Download the latest Linux archive from the [Releases](https://github.com/jatinkrmalik/vulkanize/releases) page
2. Extract the archive to a location of your choice
3. Open Terminal and navigate to the extracted directory
4. Make the script executable:
   ```bash
   chmod +x scripts/linux/vulkan-enabler.sh
   ```
5. Run the script:
   ```bash
   ./scripts/linux/vulkan-enabler.sh
   ```

### Enhanced Linux Script Features

The improved Linux script now provides:

1. **Multi-Distribution Support**:
   - Automatically detects your Linux distribution (Ubuntu, Debian, Fedora, Arch, openSUSE, Gentoo)
   - Uses the appropriate package manager for your system (apt, dnf, pacman, zypper, emerge)
   - Provides fallback options for unsupported distributions

2. **Automatic USB Access Configuration**:
   - Detects when you don't have proper USB access permissions
   - Offers to create udev rules for Android devices automatically
   - Adds your user to the plugdev group for proper device access
   - Reloads udev rules without requiring a system restart

3. **Enhanced Troubleshooting**:
   - Verifies Android device connectivity with detailed diagnostics
   - Provides device-specific information and compatibility checks
   - Includes verification tools to confirm Vulkan is properly enabled

4. **Robust Error Handling**:
   - Better package manager error detection and reporting
   - Graceful handling of sudo password prompts
   - Detailed logging of all operations for debugging

## Manual ADB Installation

If the automatic ADB installation does not work, you can manually install ADB following these instructions:

### Windows

1. Download the Android SDK Platform Tools from [Google's official site](https://developer.android.com/studio/releases/platform-tools)
2. Extract the downloaded ZIP file to a location of your choice (e.g., `C:\platform-tools`)
3. Add the Platform Tools directory to your PATH:
   - Right-click on "This PC" or "My Computer" and select "Properties"
   - Click on "Advanced system settings"
   - Click on "Environment Variables"
   - Under "System variables", find the "Path" variable, select it, and click "Edit"
   - Click "New" and add the path to the platform-tools directory (e.g., `C:\platform-tools`)
   - Click "OK" on all dialog boxes
4. Open a new Command Prompt and type `adb --version` to verify installation

### macOS

Using Homebrew:
```bash
brew install android-platform-tools
```

Manual installation:
1. Download the Android SDK Platform Tools from [Google's official site](https://developer.android.com/studio/releases/platform-tools)
2. Extract the downloaded ZIP file to a location of your choice (e.g., `~/platform-tools`)
3. Add the Platform Tools directory to your PATH by adding this line to your `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:~/platform-tools"
   ```
4. Apply the changes:
   ```bash
   source ~/.zshrc  # or source ~/.bash_profile
   ```
5. Verify installation by running:
   ```bash
   adb --version
   ```

### Linux

#### Debian/Ubuntu:
```bash
sudo apt-get update
sudo apt-get install android-sdk-platform-tools
```

#### Fedora:
```bash
sudo dnf install android-tools
```

#### Arch Linux:
```bash
sudo pacman -S android-tools
```

Manual installation:
1. Download the Android SDK Platform Tools from [Google's official site](https://developer.android.com/studio/releases/platform-tools)
2. Extract the downloaded ZIP file to a location of your choice (e.g., `~/platform-tools`)
3. Add the Platform Tools directory to your PATH by adding this line to your `~/.bashrc`:
   ```bash
   export PATH="$PATH:~/platform-tools"
   ```
4. Apply the changes:
   ```bash
   source ~/.bashrc
   ```
5. Verify installation by running:
   ```bash
   adb --version
   ```

## Enabling USB Debugging

1. On your Samsung S23 device, go to Settings
2. Scroll down and tap on "About phone"
3. Find "Software information" and tap on it
4. Tap on "Build number" 7 times to enable Developer Options
5. Go back to the main Settings screen and tap on "Developer options" (near the bottom)
6. Enable "USB debugging"
7. Connect your device to your computer via USB
8. On your device, you will get a prompt asking to allow USB debugging, tap "Allow"

## Troubleshooting Installation Issues

### Device Not Detected

1. Ensure USB debugging is enabled on your device
2. Try a different USB cable
3. Try a different USB port on your computer
4. Restart both your device and computer
5. Check if the proper driver is installed (Windows only):
   - Go to Device Manager
   - Look for any devices with warning icons
   - Install Samsung USB drivers if needed

### ADB Installation Failed

1. Try manual installation following the instructions above
2. Check your internet connection
3. Ensure you have administrator/root privileges
4. Temporarily disable antivirus software

### Permission Issues on macOS/Linux

If you get permission errors when running the script:

1. Make sure you've made the script executable:
   ```bash
   chmod +x path/to/vulkan-enabler.sh
   ```
2. If the script requires root for ADB installation, use sudo:
   ```bash
   sudo ./path/to/vulkan-enabler.sh
   ```

### Still Having Issues?

Check the [TROUBLESHOOTING.md](TROUBLESHOOTING.md) file for more detailed troubleshooting steps or open an issue on our [GitHub page](https://github.com/jatinkrmalik/vulkanize/issues).

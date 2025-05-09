# Troubleshooting Guide

This document provides solutions to common issues you might encounter when using Vulkanize.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Device Connection Issues](#device-connection-issues)
- [Vulkan Enabling Issues](#vulkan-enabling-issues)
- [Post-Vulkan Activation Issues](#post-vulkan-activation-issues)
- [Reverting Changes](#reverting-changes)
- [Log Analysis](#log-analysis)

## Installation Issues

### ADB Not Installing Automatically

**Windows:**
- If the direct download method fails:
  - Ensure your computer has internet access
  - Make sure Windows Defender or other security software is not blocking downloads
  - Try running the script as administrator
  - Ensure PowerShell is available on your system (installed by default on Windows 10 and 11)
  - If PowerShell script execution is restricted, try: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

- If you're using the manual installation approach:
  - Ensure you extract the entire platform-tools folder from the ZIP file
  - When adding to PATH, use the full path to the folder (e.g., `C:\Users\YourName\Downloads\platform-tools`)
  - After adding to PATH, restart any Command Prompt windows
  - Alternatively, copy the script directly to the platform-tools folder and run it from there
  
- General troubleshooting:
  - Try restarting your computer after installing ADB or modifying PATH
  - Temporarily disable antivirus software if it might be interfering
  - If everything else fails, copy the vulkan-enabler.bat script to your platform-tools folder and run it from there

**macOS:**
- If Homebrew installation fails:
  - Check internet connectivity
  - Try running the script with sudo: `sudo ./vulkan-enabler.sh`
  - If Homebrew is installed but ADB installation fails, try manually: `brew install android-platform-tools`
  - If you get "command not found" after Homebrew installation, restart your terminal or run: `export PATH="/opt/homebrew/bin:$PATH"` (for Apple Silicon) or `export PATH="/usr/local/bin:$PATH"` (for Intel Macs)
- If ADB is installed but not found, try adding it to your PATH manually:
  - For zsh (default on newer macOS): `echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc` then restart terminal
  - For bash: `echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile` then restart terminal

**Linux:**
- Common installation issues on Linux:
  - Missing dependencies: Try `sudo apt-get install -y android-sdk-platform-tools-common android-tools-adb` (Debian/Ubuntu)
  - Permission issues: Scripts might need execution permission with `chmod +x vulkan-enabler.sh`
  - If you get "no permissions" errors with ADB, you may need udev rules:
    ```bash
    echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android.rules
    sudo chmod a+r /etc/udev/rules.d/51-android.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    ```
  - Package manager conflicts: If you have conflicting ADB packages, try `sudo apt-get remove android-tools-adb adb` then reinstall
  - Multiple desktop environments: If you use multiple desktop environments (GNOME, KDE, etc.), auto-mounting behavior might interfere with ADB
  - Shell compatibility: If your default shell isn't bash, try running with `bash ./vulkan-enabler.sh`
  - Firewall issues: Some firewalls might block ADB, check your firewall settings
- The improved script can now handle more Linux distributions including Ubuntu, Fedora, Arch, openSUSE, and Gentoo

### Script Execution Permission Denied

**macOS/Linux:**
- Make the script executable: `chmod +x path/to/vulkan-enabler.sh`
- Run as root if needed: `sudo ./path/to/vulkan-enabler.sh`

**Windows:**
- Right-click the bat file and select "Run as administrator"
- Check if the file has been blocked by Windows: right-click > Properties > Unblock

## Device Connection Issues

### Device Not Detected

1. **Check USB Debugging:**
   - Make sure USB debugging is enabled in Developer options
   - Navigate to Settings > About phone > Software information
   - Tap "Build number" 7 times to enable Developer options
   - Go to Settings > Developer options and enable "USB debugging"
   - Try toggling it off and on again

2. **Check USB Connection:**
   - Try a different USB cable (preferably the original one that came with the device)
   - Try a different USB port on your computer
   - If using a USB hub, try connecting directly to your computer
   - Make sure your phone screen is unlocked when connecting

3. **Check Device Drivers:**
   - **Windows:** Open Device Manager and look for any devices with warning icons
   - **Windows:** Install Samsung USB drivers if needed from Samsung's website
   - **macOS:** Samsung devices typically work without additional drivers
   - **Linux:** Try `sudo apt install android-sdk-platform-tools-common` (Ubuntu/Debian) or equivalent

4. **Verify ADB Setup and Access:**
   - Open a terminal/command prompt and run: `adb devices`
   - If no devices are shown, restart the ADB server with:
     ```
     adb kill-server
     adb start-server
     adb devices
     ```
   - If you see your device with "unauthorized", look at your phone screen for the authorization prompt
   - If no authorization prompt appears, revoke USB debugging authorizations in Developer options and try again

5. **Phone-side Troubleshooting:**
   - Try different USB modes (File Transfer/MTP, PTP, etc.)
   - Navigate to Developer options and try toggling "Default USB configuration"
   - Disconnect, turn off USB debugging, reconnect, then enable USB debugging
   - Restart your phone and try again

6. **Check for System Conflicts:**
   - **Windows:** Check if other Android device management tools are running (Samsung Kies, Smart Switch)
   - **macOS:** Check Activity Monitor for processes that might interfere with ADB
   - **Linux:** Check if ADB is already running: `ps aux | grep adb`

### Multiple Devices Detected

If you have multiple Android devices connected:

1. Disconnect all devices except the S23 you want to modify
2. Alternatively, use the `-s` flag with ADB commands specifying your device serial number:
   ```
   adb -s SERIAL_NUMBER shell setprop debug.hwui.renderer skiavk
   ```
   (Replace SERIAL_NUMBER with your device's serial number from `adb devices`)

## Vulkan Enabling Issues

### Vulkan Not Being Enabled

1. **Check for Success Messages:**
   - Make sure the script ran without errors
   - Look for "Vulkan should now be enabled!" message

2. **Verify with GPUWatch:**
   - Enable GPUWatch in Developer options
   - Open an app and check if "Vulkan Renderer (skiavk)" is shown
   - If not, try running the script in aggressive mode

3. **Manual Command Check:**
   - Run these commands manually to check for errors:
     ```
     adb shell setprop debug.hwui.renderer skiavk
     adb shell am crash com.android.systemui
     adb shell am force-stop com.android.settings
     ```

4. **Device Compatibility:**
   - Ensure you're using a Samsung S23, S23+, S23 Ultra, or S23 FE
   - Check if your device is running One UI 7
   - Some system updates may affect compatibility

### Script Crashes or Hangs

1. **Run with Logging:**
   - Run the script with the `--log` parameter to enable detailed logging
   - Check the log file for error messages

2. **Check ADB Connection:**
   - Run `adb devices` to ensure your device is still connected and recognized

3. **Memory/Disk Space:**
   - Ensure your computer has sufficient free memory and disk space

## Post-Vulkan Activation Issues

### App Crashes or UI Issues

1. **Normal Behavior:**
   - Some visual artifacts in certain apps are normal
   - Some apps may not support Vulkan rendering

2. **Keyboard Issues:**
   - If Gboard/Samsung Keyboard doesn't work, try manually opening it
   - If needed, go to Settings > General Management > Keyboard list and default and reset your default keyboard

3. **Browser Issues:**
   - If default browser is reset, go to Settings > Apps > Default apps to set it again

4. **Wi-Fi Calling/VoLTE Issues:**
   - If you lose Wi-Fi Calling or VoLTE, try:
     - Toggle airplane mode on and off
     - Go to Settings > Connections > Mobile networks > VoLTE calls and toggle it
     - Restart your phone (note: this will disable Vulkan)

### Battery Life Not Improving

1. **Verify Vulkan is Active:**
   - Check with GPUWatch that Vulkan is actually being used

2. **Usage Patterns:**
   - Battery improvement is most noticeable in graphics-intensive applications
   - Background processes or poor signal may overshadow the improvement

3. **Wait for Cache Building:**
   - The first few hours after enabling Vulkan may show worse battery life while the system builds shader caches
   - Give it at least 24 hours before evaluating battery performance

### Performance Not Improving

1. **Verify Vulkan is Active:**
   - Confirm with GPUWatch as described above

2. **Check Device Temperature:**
   - Make sure your device isn't thermal throttling
   - Performance benefits are most noticeable when the device is cooler

3. **Try Different Apps:**
   - Not all apps will show the same level of improvement
   - Games and camera apps typically show the most noticeable improvement

## Reverting Changes

### How to Disable Vulkan

The Vulkan setting will automatically revert after a device restart. To manually revert:

1. Run the following command:
   ```
   adb shell setprop debug.hwui.renderer skiagl
   ```

2. Then force restart system UI:
   ```
   adb shell am crash com.android.systemui
   ```

## Log Analysis

If you're experiencing persistent issues, enable logging and analyze the log file:

1. Run the script with the `--log` parameter:
   ```
   ./vulkan-enabler.sh --log
   ```
   or
   ```
   vulkan-enabler.bat --log
   ```

2. Check the log file (vulkanize.log) in the script directory for error messages.

3. Common error messages and solutions:

   - **"Device not found"**: Check the USB connection and USB debugging settings
   - **"Command not found"**: Path issue with ADB installation
   - **"Permission denied"**: Run the script with admin/root privileges
   - **"Failure [INSTALL_FAILED_USER_RESTRICTED]"**: Disable "Verify apps over USB" in Developer options

If you're still experiencing issues, please [file an issue](https://github.com/jatinkrmalik/vulkanize/issues) with your log file and a detailed description of the problem.

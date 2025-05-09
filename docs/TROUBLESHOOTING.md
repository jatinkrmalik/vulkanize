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
- If automatic installation using winget fails:
  - Make sure you have Windows Package Manager (winget) installed
  - Try running the script as administrator
  - Check your internet connection
  - Try installing ADB manually by downloading from [Google's platform tools page](https://developer.android.com/studio/releases/platform-tools)
- Check if you have administrator privileges
- Temporarily disable antivirus software
- Check if Windows Defender is blocking the download/execution

**macOS:**
- If Homebrew installation fails, try updating Homebrew first: `brew update`
- Check if you have write permissions in `/usr/local`
- Try using sudo: `sudo brew install android-platform-tools`

**Linux:**
- Make sure your repositories are up to date: `sudo apt-get update` or equivalent
- Check if you have sudo privileges
- Try using a different package manager command as specified in the error message

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
   - Try toggling it off and on again

2. **Check USB Connection:**
   - Try a different USB cable (preferably the original one that came with the device)
   - Try a different USB port on your computer
   - If using a USB hub, try connecting directly to your computer

3. **Check Device Drivers (Windows):**
   - Open Device Manager
   - Look for any devices with warning icons
   - Install Samsung USB drivers if needed

4. **Verify ADB Sees the Device:**
   - Open a terminal/command prompt and run: `adb devices`
   - If you see your device with "unauthorized", disconnect and reconnect while watching your phone screen for the authorization dialog

5. **Restart ADB Server:**
   - Run the following commands:
     ```
     adb kill-server
     adb start-server
     adb devices
     ```

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

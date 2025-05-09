# Vulkanize

[![License: MIT](https://img.shields.io/badge/License-MIT-g.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-black.svg)](https://github.com/jatinkrmalik/vulkanize)
[![GitHub release](https://img.shields.io/github/release/jatinkrmalik/vulkanize.svg)](https://github.com/jatinkrmalik/vulkanize/releases)

**Force Vulkan Graphics on Samsung S23 Devices Running One UI 7**

Vulkanize is a cross-platform utility that enables Vulkan graphics rendering on Samsung S23 series devices. This can lead to significant performance improvements, reduced heat generation, and better battery life.

**Note on Device Compatibility:** While Vulkanize is primarily focused on S23 devices due to specific One UI 7 changes, the underlying Vulkan enablement scripts can potentially work on other Android devices. However, users trying this on non-S23 devices do so at their own risk. See the [Technical Details](#device-compatibility-and-wider-applicability) section for more information.


## 🚀 Features

- Force Vulkan graphics rendering on Samsung S23 devices
- Cross-platform support: Windows, macOS, and Linux
- Interactive UI mode with clear instructions
- CLI mode for experienced users and automation
- Automatic ADB installation assistance
- Device detection with clear error messages
- Normal and aggressive application stopping modes
- Vulkan verification guidance
- Detailed logging for troubleshooting

## 🆕 Latest Enhancements

- **Improved macOS Support**:
  - Automatic Homebrew installation with proper PATH configuration
  - Support for both Intel and Apple Silicon Macs
  - Better shell detection and configuration (zsh/bash)
  - Enhanced ADB installation error handling

- **Expanded Linux Compatibility**:
  - Multi-distribution support (Ubuntu, Debian, Fedora, Arch, openSUSE, Gentoo)
  - Automatic udev rules configuration for Android devices
  - More robust ADB installation across package managers
  - Better user permission handling

- **Enhanced Device Detection**:
  - Smart ADB server management
  - Improved unauthorized device handling
  - Device model verification to confirm S23 compatibility
  - Better ADB communication troubleshooting

## 📋 Requirements

- Samsung S23, S23+, S23 Ultra, or S23 FE device
- USB cable
- USB debugging enabled on your device
- Windows, macOS, or Linux computer
- ADB (Android Debug Bridge) - can be installed through the script if not present

## 📥 Installation

### Quick Start

1. Download the latest release from the [Releases](https://github.com/jatinkrmalik/vulkanize/releases) page
2. Extract the archive to a location of your choice
3. Follow the platform-specific instructions below

### Windows

1. Connect your device via USB cable
2. Enable USB debugging on your device
3. Run `vulkan-enabler.bat` by double-clicking on it
4. If ADB is not found, the script will:
   - Offer to download and install ADB directly from Google's official site
   - Or provide detailed manual installation instructions, including how to add platform-tools to PATH
   - Alternatively, you can copy the script into the platform-tools folder and run it from there
5. Follow the on-screen instructions

### macOS

1. Connect your device via USB cable
2. Enable USB debugging on your device
3. Open Terminal and navigate to the extracted folder
4. Make the script executable: `chmod +x scripts/mac/vulkan-enabler.sh`
5. Run the script: `./scripts/mac/vulkan-enabler.sh`
6. The script will:
   - Check for Homebrew and offer to install it if missing
   - Configure your shell profile automatically (zsh or bash)
   - Install ADB via Homebrew if needed
   - Guide you through the entire process with clear instructions

### Linux

1. Connect your device via USB cable
2. Enable USB debugging on your device
3. Open Terminal and navigate to the extracted folder
4. Make the script executable: `chmod +x scripts/linux/vulkan-enabler.sh`
5. Run the script: `./scripts/linux/vulkan-enabler.sh`
6. The script will:
   - Detect your Linux distribution automatically
   - Install ADB using the appropriate package manager
   - Set up proper device permissions with udev rules if needed
   - Provide comprehensive device detection and troubleshooting

For more detailed installation instructions, see [INSTALLATION.md](docs/INSTALLATION.md).

## 📱 Usage

### Interactive Mode

All scripts provide an interactive menu with the following options:

1. **Check device connection**: Verify your device is properly connected and recognized
2. **Enable Vulkan (Normal mode)**: Apply Vulkan with minimal app restarts
3. **Enable Vulkan (Aggressive mode)**: Apply Vulkan with more thorough app restarts
4. **Verify Vulkan status**: Instructions to confirm Vulkan is enabled
5. **Help and information**: Details about the tool and its effects
6. **Exit**: Close the application

### Command Line Mode

All scripts support command-line parameters for automation:

```
# Windows
vulkan-enabler.bat --simple --normal

# macOS/Linux
./vulkan-enabler.sh --simple --aggressive
```

Available options:
- `--simple`: Run in simple mode with fewer prompts
- `--log`: Enable detailed logging
- `--normal`: Enable Vulkan in normal mode and exit
- `--aggressive`: Enable Vulkan in aggressive mode and exit
- `--help`: Show help information

## 🔍 Verification

To verify that Vulkan is enabled:

1. On your phone, go to Settings
2. Open Developer Options (tap Build Number 7 times if not enabled)
3. Enable GPUWatch
4. Open any app (like the dialer)
5. Look for "Vulkan Renderer (skiavk)" in the overlay

![image](https://github.com/user-attachments/assets/7ba3488f-21bb-4714-8e0d-d5c9aca4efd5)


## ⚠️ Known Issues

- The Vulkan setting reverts after device reboot - run the script again to re-enable
- Some apps may display visual artifacts when using Vulkan
- Some apps may not run correctly under Vulkan on all devices
- Default browser and keyboard settings may reset
- Possible loss of WiFi-Calling/VoLTE (fix by toggling SIM in settings)
- On non-S23 devices, older processors may experience increased battery consumption and bugs. AOSP ROMs are not recommended for some methods.

For troubleshooting and solutions, see [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## 📚 Technical Details

Vulkanize works by setting the `debug.hwui.renderer` property to `skiavk`, which forces the system to use Vulkan instead of OpenGL ES for rendering. The script then forces key system components to restart to apply the new setting.

### Device Compatibility and Wider Applicability

The Vulkan enablement scripts aren't exclusively for S23 phones, though they've become particularly relevant for these devices due to Samsung's specific decisions with One UI 7.

**Why S23 Is the Focus:**
The scripts are primarily discussed in the context of S23 devices because:
- One UI 7 specifically reverted S23 devices from Vulkan (which was briefly used in Beta 1) back to OpenGL as the default graphics renderer.
- This change caused notable performance issues, heating problems, and reduced battery life specifically on S23 devices.
- The community response has been particularly strong from S23 users who experienced better performance during the beta period when Vulkan was enabled.

**Applicability to Other Devices:**
This fix can potentially work on other Android devices with some important considerations:
- **Samsung Galaxy Devices:** The methods described can work on many Samsung Galaxy devices beyond just the S23 series.
- **Android Version Requirements:** Vulkan is available on Android from Android 7 (API level 24) and up, with all 64-bit devices from Android 10 supporting Vulkan 1.1.
- **Hardware Requirements:** Performance benefits are more noticeable on devices with more powerful processors (Snapdragon 888 or better is recommended).
- **Device-Specific Variations:** While the basic ADB commands (like `setprop debug.hwui.renderer skiavk`) are similar across devices, the specific apps that need to be force-stopped might vary.

**Warnings for Non-S23 Devices:**
If you try this on other devices:
- Older processors may experience increased battery consumption and bugs.
- AOSP ROMs (non-Samsung Android) are not recommended for some of these methods.
- Not all apps will run properly under Vulkan on all devices.
- The change will revert after rebooting, regardless of device type.

The focus on S23 devices mainly reflects where the problem is most acute, rather than a technical limitation of the solution itself.

For more technical information, see [TECHNICAL.md](docs/TECHNICAL.md).

## 📈 Performance Improvements

Users have reported the following improvements after enabling Vulkan:

- Up to 30% better performance in demanding applications
- 5-10°C cooler operation under load
- 15-20% better battery life

*Note: Your results may vary depending on your specific device, apps, and usage patterns.*

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- Thanks to the original discoverers of the Vulkan forcing method for Samsung devices
- The Android development community for tools and documentation
- All contributors and testers who have helped improve this project

## ⚠️ Disclaimer

This tool is provided "as is" without warranty of any kind. Use at your own risk. The authors are not responsible for any damage to your device or loss of data that may result from the use of this tool.

Always make backups of important data before making system changes.

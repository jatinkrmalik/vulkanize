# Vulkanize

**Force Vulkan Graphics on Samsung S23 Devices Running One UI 7**

Vulkanize is a cross-platform utility that enables Vulkan graphics rendering on Samsung S23 series devices. This can lead to significant performance improvements, reduced heat generation, and better battery life.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/jatinkrmalik/vulkanize.svg)](https://github.com/jatinkrmalik/vulkanize/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)](https://github.com/jatinkrmalik/vulkanize)

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
4. If ADB is not found, the script will attempt to install it automatically using Windows Package Manager (winget)
5. Follow the on-screen instructions

### macOS

1. Connect your device via USB cable
2. Enable USB debugging on your device
3. Open Terminal and navigate to the extracted folder
4. Make the script executable: `chmod +x scripts/mac/vulkan-enabler.sh`
5. Run the script: `./scripts/mac/vulkan-enabler.sh`
6. Follow the on-screen instructions

### Linux

1. Connect your device via USB cable
2. Enable USB debugging on your device
3. Open Terminal and navigate to the extracted folder
4. Make the script executable: `chmod +x scripts/linux/vulkan-enabler.sh`
5. Run the script: `./scripts/linux/vulkan-enabler.sh`
6. Follow the on-screen instructions

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
- Some apps may not run correctly under Vulkan
- Default browser and keyboard settings may reset
- Possible loss of WiFi-Calling/VoLTE (fix by toggling SIM in settings)

For troubleshooting and solutions, see [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## 📚 Technical Details

Vulkanize works by setting the `debug.hwui.renderer` property to `skiavk`, which forces the system to use Vulkan instead of OpenGL ES for rendering. The script then forces key system components to restart to apply the new setting.

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

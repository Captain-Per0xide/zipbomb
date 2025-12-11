# 💣 Zip Bomb Generator

<div align="center">

**A 42.zip-style recursive zip bomb generator with unique file naming**

[![C](https://img.shields.io/badge/language-C-blue.svg)](<https://en.wikipedia.org/wiki/C_(programming_language)>)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/license-Educational-orange.svg)](LICENSE)

</div>

---

## ⚠️ WARNING

This tool creates **decompression bombs** that can rapidly consume disk space and system resources. Use **ONLY** for:

- Educational purposes
- Security testing in controlled environments
- Understanding compression vulnerabilities

**DO NOT:**

- Send these files to others without their explicit consent
- Upload to public servers or cloud storage
- Use maliciously or irresponsibly

**You are responsible for any consequences of using this tool.**

---

## 📖 What is a Zip Bomb?

A **zip bomb** (decompression bomb) is a malicious archive file designed to crash or disable a system by expanding to enormous sizes when extracted. The famous **42.zip** is only 42 KB but expands to 4.5 PB (petabytes) when fully decompressed!

### How It Works

```
layer0.zip (637 MB)
├── L1_archive0000.zip ─┐
├── L1_archive0001.zip  ├─► L2_archive0000.zip ─┐
├── ...                 │                       ├─► L3_document0000.txt (10 MB)
└── L1_archive0009.zip ─┘                       ├─► L3_document0001.txt (10 MB)
                                                └─► ... (100 MB total)

Each layer multiplies the data:
Layer 0: 637 MB (compressed)
Layer 1: 10 copies → 6.37 GB
Layer 2: 1 copy inside each → 6.37 GB
Layer 3: 10 text files → 100 MB per zip

Total expansion: 637 MB → ~10 GB+ (depending on configuration)
```

---

## 🚀 Features

- ✨ **Configurable depth** - Create multi-layer nested archives
- 🔢 **Adjustable expansion** - Control base file size and copies per layer
- 🎯 **Unique filenames** - Fixed version prevents file overwrites during extraction
- 📊 **Real-time statistics** - Track compression ratios and expansion
- 🔬 **Safe testing scripts** - Simulate extraction with safety limits
- ⚡ **Efficient generation** - Reuses compressed data for faster creation

---

## 🛠️ Installation

### Prerequisites

- GCC compiler (MinGW-w64 on Windows)
- zlib library
- CMake (for building)
- Unix-like environment (Linux/macOS) or Windows with PowerShell

### Build

```bash
# Using CMake (recommended)
mkdir build && cd build
cmake ..
make

# On Windows with MinGW
cmake -G "MinGW Makefiles" ..
mingw32-make

# Or directly with GCC
gcc -O2 -Wall -o gen_test_gzip main.c -lz
```

---

## 📚 Usage

### Basic Usage

```bash
# Generate with defaults (3 layers, 10 MB base, 10 copies per layer)
./bin/gen_test_gzip

# Custom configuration
./bin/gen_test_gzip [depth] [base_size_mb] [copies_per_layer]
```

### Examples

```bash
# Small test bomb (3 layers, 5 MB, 5 copies)
./bin/gen_test_gzip 3 5 5

# Medium bomb (4 layers, 10 MB, 10 copies) - ~10 GB expansion
./bin/gen_test_gzip 4 10 10

# Large bomb (5 layers, 20 MB, 10 copies) - WARNING: ~200 GB expansion!
./bin/gen_test_gzip 5 20 10
```

### Output

```
╔════════════════════════════════════════════════╗
║    42.zip Style Zip Bomb Generator (FIXED)    ║
╚════════════════════════════════════════════════╝

Configuration:
  Depth: 4 layers
  Base file size: 10 MB
  Copies per layer: 10
  Theoretical expansion: 10.00 GB

=== Layer 1/4 (Data Layer) ===
Creating data layer: layer3.zip (10 files × 10MB each)...
  Progress: 10/10
  Created: layer3.zip (101.00 KB on disk, expands to 100.00 MB)

...

⚠️  WARNING: layer0.zip
    File size: 637.00 KB
    Expands to: 10.00 GB
    Expansion: 16064x
```

---

## 🧪 Testing & Extraction Scripts

### 1. Recursive Extraction (Bash - Deletes Zips)

Simulates a typical extraction attack where archives are deleted after extraction:

```bash
./simulate_recursive.sh
```

**Result:** Only innermost files remain (~100 MB)

### 2. Full Expansion (PowerShell - Keeps Everything)

Shows the true maximum expansion by keeping all extracted files:

```powershell
# Basic usage
.\simulate_full_expansion.ps1

# With custom parameters
.\simulate_full_expansion.ps1 -StartFile "layer0.zip" -MaxCycles 5
```

**Result:** All layers and files preserved, showing full expansion

### 3. Full Expansion (Batch File - Windows)

Windows batch file version using the built-in `tar` command:

```cmd
simulate_full_expansion.bat
```

### Safety Features

- **Maximum cycle limit** - Stops after 5 extraction cycles
- **Sandboxed extraction** - Creates separate extraction directories
- **Progress monitoring** - Real-time size and file count tracking
- **Cross-platform** - Scripts for both Unix/Linux and Windows

---

## 💥 File Scattering Feature

The PowerShell script includes an advanced **file scattering** feature that randomly distributes extracted files across a target location, simulating a real-world attack scenario.

### Usage

```powershell
# Enable scattering with interactive location prompt
.\simulate_full_expansion.ps1 -EnableScatter

# Specify target location directly
.\simulate_full_expansion.ps1 -ScatterLocation "C:\Users\YourName\Documents\Test"

# Full command with all options
.\simulate_full_expansion.ps1 -StartFile "layer0.zip" -MaxCycles 5 -ScatterLocation "C:\Target\Path" -EnableScatter
```

### Parameters

| Parameter          | Description                     | Default                    |
| ------------------ | ------------------------------- | -------------------------- |
| `-StartFile`       | Initial zip bomb file           | `layer0.zip`               |
| `-MaxCycles`       | Maximum extraction cycles       | `5`                        |
| `-ScatterLocation` | Target directory for scattering | (prompted if not provided) |
| `-EnableScatter`   | Enable file scattering mode     | `$false`                   |

### How Scattering Works

1. **Extraction Phase** - Extracts zip bomb into `full_expansion_zone`
2. **Scanning Phase** - Recursively scans target location for all subdirectories
3. **Scattering Phase** - Randomly distributes all `.txt` files to random folders
   - Handles filename conflicts by appending numbers
   - Copies files (doesn't move) to preserve originals
4. **Logging Phase** - Creates `scatter.log` with detailed file locations

### Scatter Log Format

The `scatter.log` file tracks every scattered file:

```
=== File Scattering Log ===
Timestamp: 2025-12-11 21:09:36
Source: C:\Users\Ranju\...\full_expansion_zone
Target: C:\Users\Ranju\Documents\Test
Total Files: 1024

Scattered Files:
---------------
[OK] L4_document0000.txt -> C:\...\Test\3\L4_document0000.txt
[OK] L4_document0001.txt -> C:\...\Test\6\L4_document0001.txt
...
```

### Cleanup Script

Use `delete_scatter.ps1` to safely remove all scattered files:

```powershell
# Preview what will be deleted (safe mode)
powershell -ExecutionPolicy Bypass -File .\delete_scatter.ps1 -WhatIf

# Delete with confirmation prompt
powershell -ExecutionPolicy Bypass -File .\delete_scatter.ps1

# Force deletion without confirmation
powershell -ExecutionPolicy Bypass -File .\delete_scatter.ps1 -Force

# Use custom log file
powershell -ExecutionPolicy Bypass -File .\delete_scatter.ps1 -LogFile "custom.log"
```

### Cleanup Features

- ✅ **WhatIf Mode** - Preview files without deleting
- ✅ **Confirmation Prompt** - Prevents accidental deletion
- ✅ **Force Mode** - Skip confirmation for automated scripts
- ✅ **Progress Tracking** - Shows deletion progress
- ✅ **Size Calculation** - Displays total space to be freed
- ✅ **Error Handling** - Logs failed deletions

### Safety Warnings

⚠️ **File scattering will:**

- Scatter files across the entire target directory tree
- Require proper permissions to write to target folders
- Consume disk space equal to the extracted bomb size
- Create hundreds or thousands of files in random locations

**Before scattering:**

- Ensure you have sufficient disk space
- Verify you have write permissions
- Keep the `scatter.log` file for cleanup
- Use a test directory first
- 5-second countdown allows cancellation (Ctrl+C)

---

## 🔧 Technical Details

### File Structure

- **`main.c`** - Core zip bomb generator with proper ZIP format implementation
- **`CMakeLists.txt`** - Build configuration for cross-platform compilation
- **`simulate_recursive.sh`** - Bash script for recursive extraction with cleanup
- **`simulate_full_expansion.sh`** - Bash script for maximum expansion testing
- **`simulate_full_expansion.ps1`** - PowerShell script with file scattering feature
- **`simulate_full_expansion.bat`** - Windows batch file using tar command
- **`delete_scatter.ps1`** - PowerShell cleanup script for scattered files
- **`scatter.log`** - Generated log file tracking scattered file locations

### Compression Strategy

1. **Data Layer**: Creates highly compressible text files with repeating patterns
2. **Nested Layers**: Stores inner zips without additional compression (DEFLATE already applied)
3. **Unique Naming**: Prefixes files with layer numbers (L0*, L1*, etc.) to prevent overwrites

### ZIP Format Implementation

- Manual ZIP file structure creation
- Proper Local File Headers
- Central Directory implementation
- End of Central Directory records
- CRC32 checksums for integrity

---

## 📊 Performance

### Compression Ratios

| Configuration              | Disk Size | Expands To | Ratio    |
| -------------------------- | --------- | ---------- | -------- |
| 3 layers, 10 MB, 10 copies | ~637 KB   | ~10 GB     | 16,000:1 |
| 4 layers, 10 MB, 10 copies | ~6.3 MB   | ~100 GB    | 16,000:1 |
| 5 layers, 10 MB, 10 copies | ~63 MB    | ~1 TB      | 16,000:1 |

### Generation Speed

- Small bomb (3 layers): ~2-5 seconds
- Medium bomb (4 layers): ~10-20 seconds
- Large bomb (5 layers): ~1-2 minutes

---

## 🛡️ Safety & Ethics

### Responsible Use

✅ **Acceptable:**

- Testing antivirus software
- Educational demonstrations
- Security research
- Controlled environment testing

❌ **Unacceptable:**

- Malicious distribution
- Targeting production systems
- Unauthorized testing
- Evading security measures

### Legal Considerations

Creating and possessing zip bombs is generally legal for research, but **using them maliciously is illegal** in most jurisdictions. Always:

- Obtain written permission before testing on any system
- Clearly label files as test/dangerous
- Never upload to public services
- Follow your organization's security policies

---

## 🐛 The Fix: Unique Naming

### The Problem

Original 42.zip uses identical filenames (`0.zip`) in each layer, causing overwrites during extraction:

```
layer0.zip
├── 0.zip  ← All 10 copies named "0.zip"
├── 0.zip  ← Overwrites previous!
└── ...
```

### The Solution

This implementation uses **layer-prefixed unique names**:

```
layer0.zip
├── L1_archive0000.zip  ← Unique!
├── L1_archive0001.zip
├── L1_archive0002.zip
└── ...
```

**Result:** True recursive extraction without overwrites, achieving full theoretical expansion.

---

## 📝 Examples

### Small Test Case

```bash
# Generate bomb
$ ./bin/gen_test_gzip 2 5 3

# Extract and test (PowerShell)
.\simulate_full_expansion.ps1 -StartFile "layer0.zip" -MaxCycles 3
```

Creates:

- `layer0.zip` (~15 KB)
- Expands to 45 MB (5 MB × 3 × 3)
- 9 text files total

### Standard Bomb

```bash
# Generate bomb
$ ./bin/gen_test_gzip 3 10 10

# Extract and scatter (PowerShell)
.\simulate_full_expansion.ps1 -ScatterLocation "C:\Test" -EnableScatter
```

Creates:

- `layer0.zip` (~637 KB)
- Expands to 10 GB
- 1,000 text files total

### Complete Workflow Example

```powershell
# 1. Generate zip bomb
.\bin\zipbomb.exe 4 10 10

# 2. Extract and scatter files
.\simulate_full_expansion.ps1 -ScatterLocation "C:\TestFolder"

# 3. Preview scattered files
powershell -ExecutionPolicy Bypass -File .\delete_scatter.ps1 -WhatIf

# 4. Check the log
Get-Content scatter.log

# 5. Clean up scattered files
powershell -ExecutionPolicy Bypass -File .\delete_scatter.ps1
```

---

## 🤝 Contributing

This is an educational project. If you find bugs or have improvements:

1. Test thoroughly in isolated environments
2. Document changes clearly
3. Ensure safety features remain intact
4. Follow responsible disclosure

---

## 📚 References

- [42.zip Wikipedia](https://en.wikipedia.org/wiki/Zip_bomb)
- [ZIP File Format Specification](https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT)
- [Understanding Compression Bombs](https://www.bamsoftware.com/hacks/zipbomb/)

---

## 📄 License

Educational use only. Use responsibly and ethically.

---

## 🙏 Acknowledgments

Inspired by the legendary **42.zip** and research into decompression vulnerabilities.

---

<div align="center">

**Remember: With great power comes great responsibility** 🕷️

Made for educational purposes | Use wisely | Test safely

</div>

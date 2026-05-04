# ⚡ SD WebUI Forge - Universal Portable Installer

[![Windows](https://img.shields.io/badge/Platform-Windows-0078D6?style=flat-square&logo=windows)](https://www.microsoft.com/windows)
[![Python](https://img.shields.io/badge/Python-3.13.12-3776AB?style=flat-square&logo=python)](https://www.python.org/)
[![UV](https://img.shields.io/badge/Powered%20By-UV-purple?style=flat-square&logo=python)](https://github.com/astral-sh/uv)
[![Git](https://img.shields.io/badge/Git-Portable-F05032?style=flat-square&logo=git)](https://git-scm.com/)
![Portable](https://img.shields.io/badge/Type-Portable-success?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](https://opensource.org/licenses/MIT)

A lightning-fast, zero-dependency, **fully portable** installer for [SD WebUI Forge](https://github.com/Haoming02/sd-webui-forge-classic).

<img width="1920" height="1080" alt="3840x2160" src="https://github.com/user-attachments/assets/ae97928c-8bb7-4604-83c5-482339878686" />

This script allows you to choose between the **Classic** (Stable) and **Neo** (Experimental) branches. It sets up a self-contained environment using **UV**, making installation and updates significantly faster than standard methods.

## ✨ Features

*   **🌍 Universal:** Choose to install **Forge Classic** or **Forge Neo** from a simple menu.
*   **⚡ Ultra-Fast:** Uses [uv](https://github.com/astral-sh/uv) for package management, drastically reducing install times.
*   **📦 Fully Portable:** Includes Embedded Python 3.13 and [MinGit](https://github.com/git-for-windows/git). No global installation required.
*   **🔧 Auto-Fixes:** Automatically installs pre-compiled `insightface` wheels for Classic (fixing common installation errors).
*   **🧹 Smart Cleanup:** Automatically removes temporary setup files after installation to keep your folder clean.

## 🛠️ Installation Guide

1.  [![Download Installer](https://img.shields.io/badge/⬇️%20Download---?style=flat-square&logo=windows&logoColor=white)](https://raw.githubusercontent.com/Merserk/sd-webui-forge-universal-portable/main/install_forge_universal.bat) the `install_forge_universal.bat` file.
2.  **Place it** in a folder where you want the installation to live (e.g., `C:\AI\SD Forge Neo and Classic\`).
    *   *Tip: Avoid placing it in deeply nested folders to prevent path length limits.*
3.  **Double-click** the script.
4.  **Select your Edition:**
    *   Press **[1]** for **Neo** (Newest features, experimental).
    *   Press **[2]** for **Classic** (Stable, traditional).
5.  Wait for the installer to finish.

> **Note:** You can run the installer again to install the *other* version side-by-side in the same folder!

## 🎮 How to Use

Depending on which version you selected, you will see specific launch files:

### For Forge Neo:
*   **`run_neo.bat`**: Starts the WebUI.
*   **`update_neo.bat`**: Updates the repository and packages.

### For Forge Classic:
*   **`run_classic.bat`**: Starts the WebUI.
*   **`update_classic.bat`**: Updates the repository and packages.

## 📂 Directory Structure

Your folder will look like this (example showing both installed):

```text
SD Forge Neo and Classic/
├── sd-webui-forge-neo/          # Neo Edition Folder
├── sd-webui-forge-classic/      # Classic Edition Folder
│
├── install_forge_universal.bat  # Installer for Neo and Classic
│
├── run_neo.bat                  # Launcher for Neo
├── update_neo.bat               # Updater for Neo
│
├── run_classic.bat              # Launcher for Classic
└── update_classic.bat           # Updater for Classic
```

## 📖 Project Lineage & History

Understanding the different versions of the WebUI can be confusing. Here is how this project came to be:

* 🟢 **[Automatic1111] Stable Diffusion WebUI**<br>
  The original, foundational Gradio-based interface for Stable Diffusion that started it all.
  * 🟡 **↳ [lllyasviel] SD WebUI Forge**<br>
    A major fork of A1111 optimized for better resource management, significantly faster inference, and lower VRAM usage.
    * 🔵 **↳ [Haoming02] Forge Classic & Neo**<br>
      When the original Forge slowed in updates, it was forked by Haoming02 to keep the project alive, splitting into two distinct branches:
      * 🟦 **Forge Classic:** Ensure maximum compatibility with older, legacy extensions.
      * 🟧 **Forge Neo:** Modernized UI, newer features, and better performance.

**This repository provides a universal, portable installer to easily run either the Classic or Neo branch.**

## 🤝 Credits

*   **SD WebUI Forge:** Maintained by [Haoming02](https://github.com/Haoming02/sd-webui-forge-classic).
*   **UV:** High-performance Python package installer by [Astral](https://github.com/astral-sh/uv).
*   **InsightFace Wheels:** Provided by [Gourieff](https://github.com/Gourieff/Assets).
*   **Original Projects:** Based on SD WebUI by [Automatic1111](https://github.com/automatic1111/stable-diffusion-webui) and Forge by [lllyasviel](https://github.com/lllyasviel/stable-diffusion-webui-forge).
*   **Python:** The core programming language environment by [Python Software Foundation](https://www.python.org/).
*   **MinGit:** Minimal, portable version of Git for Windows by the [Git for Windows Team](https://github.com/git-for-windows/git).

---
*If you find this useful, give the repository a star! ⭐*

# Stationeers Dedicated Server Control v2.4.1

![Go](https://img.shields.io/badge/Go-1.22.1-blue)
![License](https://img.shields.io/github/license/jacksonthemaster/StationeersServerUI)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)
![Docker](https://img.shields.io/badge/Docker-available-lightgrey)


| UI Overview | Configuration | Backup Management |
|:-----------:|:-------------:|:-----------------:|
| ![UI Overview](media/UI-1.png) | ![Configuration](media/UI-2.png) | ![Backup Management](media/UI-3.png) |

## Known Bug
The Server config page got a rework. I broke the functionality doing this. Whoopsies. Please use Settings.xml in the main Server dir until I fix this issue. The SaveName on the Config Page still has to be specified for the backup system to work properly, and to be able to restore from Discord.
OK Sorry guys I still haven't published the fix. I was working on it, I bet it is mostly finished but I didn't really need it and sadly did not finish. IF somebody wants to use this software - ping me, I will finish it for you!

## Introduction

Stationeers Dedicated Server Control is a user-friendly, web-based tool for managing a Stationeers dedicated server. It features an intuitive retro computer-themed interface, allowing you to easily start and stop the server, view real-time server output, manage configurations, and handle backups—all from your web browser.

Additionally, it offers full Discord integration, enabling you and your community to monitor and manage the server directly from a Discord server. Features include real-time server status updates, console output, and the ability to start, stop, and restore backups via Discord commands.

**Important:** For security reasons, do not expose this UI directly to the internet without a secure authentication mechanism. Do not port forward the UI directly.

## Table of Contents

- [Stationeers Dedicated Server Control v2.4.1](#stationeers-dedicated-server-control-v241)
  - [Known Bug](#known-bug)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Quick Installation Instructions](#quick-installation-instructions)
  - [First-Time Setup](#first-time-setup)
  - [Discord Integration](#discord-integration)
    - [Discord Integration Features](#discord-integration-features)
    - [Discord Notifications](#discord-notifications)
  - [Discord Integration Setup](#discord-integration-setup)
  - [Usage](#usage)
    - [Web Interface](#web-interface)
      - [Discord Commands](#discord-commands)
  - [Running with Docker](#running-with-docker)
    - [Building the Docker Image](#building-the-docker-image)
  - [Running with Docker Compose](#running-with-docker-compose)
  - [Important Security Note](#important-security-note)
  - [Important Notes](#important-notes)
  - [License](#license)
  - [Contributing](#contributing)
  - [Acknowledgments](#acknowledgments)

## Features
- Place Executable in an Empty folder and run it, Stationeers Server ready.
- Auto Update the Server at Software Startup
- Auto SteamCMD Setup
- Start and stop the Stationeers server with ease.
- View real-time server console output.
- Manage server configurations through a user-friendly interface.
- List and restore backups, with enhanced backup management features.
- Fully functional REST API for advanced operations (optional).
- Full Discord integration for server monitoring and management.
- Auto Deletion of Backups older than 2 days.

## Requirements

- Windows OS (tested on Windows; Linux support experimental).
- Administrative privileges on the server machine.
  - (Root/sudo access required to install steamcmd pre-requirements on linux)
- An empty folder of your choice to install the server control software.

## Installation

### Quick Installation Instructions

1. **Download and Run the Application**

   - Download the latest release executable file (`.exe`) from the [releases page](https://github.com/JacksonTheMaster/StationeersServerUI/releases).
   - Place it in an empty folder of your choice.
   - Run the executable. A console window will open, displaying output.

2. **Access the Web Interface**

   - Open your web browser.
   - Navigate to `http://<IP-OF-YOUR-SERVER>:8080`.
     - Replace `<IP-OF-YOUR-SERVER>` with the local IP address of your server. You can find this by opening Command Prompt and typing `ipconfig`.

3. **Allow External Connections (Optional)**

   - If you want others on your network to access the server UI or the gameserver, you'll need to adjust your Windows Firewall settings:
     - Go to **Control Panel > System and Security > Windows Defender Firewall**.
     - Click on **Advanced settings**.
     - Select **Inbound Rules** and click on **New Rule...**.
     - Choose **Port** and click **Next**.
     - for the gameserver, select **TCP** and enter `27015, 27016` in the **Specific local ports** field.
     - for the WebUI(This Software), select **TCP** and enter `8080` in the **Specific local ports** field.
     - Click **Next**.
     - Choose **Allow the connection** and click **Next**.
     - Select the network profiles of your choise (Domain, Private, Public) and click **Next**.
     - Name the rule (e.g., "Stationeers Server Ports") and click **Finish**.
   - **Note:** Depending on your network setup, you may need to configure port forwarding on your router to allow external connections. Please refer to your router's documentation for instructions.


## First-Time Setup

To successfully run the server for the first time, follow these steps:
Follow the Installation Instructions above.
Only turn to this section when the magenta Text in the Console tells you to do so.

1. **Prepare Your Save File**

   - Copy an existing Stationeers save folder into the `/saves` directory created during the installation.

2. **Configure the Save File Name**

   - In the web interface, click on the **Config** button.
   - Enter the name of your save folder in the **Save File Name** field.
   - You might restart the Software at this point to be sure, but it's technically not necessary.

3. **Start the Server**

   - Return to the main page of the web interface.
   - Click on the **Start Server** button.
   - The server will begin to start up, and you can monitor the console output in real-time.

## Discord Integration

### Discord Integration Features

- **Real-Time Monitoring:**
  - View server status and console output directly in Discord.
  - Receive notifications for server events such as player connections/disconnections, exceptions, and errors.
- **Server Management Commands:**
  - Start, stop, and restart the server.
  - Restore backups.
  - Ban and unban players by their Steam ID.
  - Update server files (currently supports the stable branch only).
- **Access Control:**
  - Utilize Discord's role system for granular access control over server management commands and notifications.

### Discord Notifications

The bot can send notifications for the following events:

- **Server Ready:** Notifies when the server status changes to ready.
- **Player Connection/Disconnection:** Alerts when a player connects or disconnects.
- **Exceptions and Errors:** Sends notifications when exceptions or errors are detected, including Cysharp error detection.
- **Player List:** Provides a table of connected players and their Steam IDs.

## Discord Integration Setup

1. **Create a Discord Bot**

   - Follow the instructions on [Discord's Developer Portal](https://discord.com/developers/applications) to create a new bot and add it to your Discord server.

2. **Obtain the Bot Token**

   - In the bot settings, under the **Bot** tab, copy the **Token**. Keep this token secure.

3. **Configure the Bot in the Server Control UI**

   - In the web interface, click on the **Further Setup** button.
   - Enter the bot's token in the **Discord Token** field.
   - Create a Discord Server if not already done.
   - Create a Discord Channel for the Server Control (commands), Server Status, and Server Log, and the Control Panel. Additionally, create a Discord Channel for the Error Channel.

   - Input the **Channel IDs** on the further Setup Page.
     - **Server Control Channel ID**: For sending commands to the bot.
     - **Server Status Channel ID**: For receiving server status notifications.
     - **Server Log Channel ID**: For viewing real-time console output.
     - **Control Panel Channel ID**: For the Control Panel.
     - **Error Channel ID**: For the Error Channel.
   - **Note:** To get a channel's ID, right-click on the channel in Discord and select **Copy ID**.

4. **Enable Discord Integration**

   - In the **Further Setup** page, check the **Discord Enabled** checkbox.

5. **Restart the Application**

   - Close the application and run the executable again to apply the changes.

## Usage

### Web Interface

- **Start/Stop Server:** Use the **Start Server** and **Stop Server** buttons on the main page.
- **View Server Output:** Monitor real-time console output directly in the web interface.
- **Manage Configurations:**
  - Click on the **Config** button to edit server settings.
  - Ensure all settings are correct before starting the server.
- **Backup Management:**
  - Access the **Backups** page to list and restore backups.
  - Backups are grouped and have improved deletion logic for easier management.

#### Discord Commands

| Command                       | Description                                                         |
|-------------------------------|---------------------------------------------------------------------|
| `!start`                      | Starts the server.                                                  |
| `!stop`                       | Stops the server.                                                   |
| `!restore:<backup_index>`     | Restores a backup at the specified index.                           |
| `!list:<number/all>`          | Lists recent backups (defaults to 5 if number not specified).       |
| `!ban:<SteamID>`              | Bans a player by their SteamID.                                     |
| `!unban:<SteamID>`            | Unbans a player by their SteamID.                                   |
| `!update`                     | Updates the server files if a game update is available.             |
| `!help`                       | Displays help information for the bot commands.                     |

## Running with Docker

### Building the Docker Image

To build the Docker image for the Stationeers Dedicated Server Control, follow these steps:

1. **Clone the Repository**

   ```sh
   git clone https://github.com/mitoskalandiel/StationeersServerUI.git
   cd StationeersServerUI
   ```

2. **Build the Repository**

  `docker build -t stationeers-server-ui:latest .`

## Running with Docker Compose

To run the Stationeers Dedicated Server Control using Docker Compose, follow these steps:

1. **Create a docker-compose.yml File**

Ensure you have a docker-compose.yml file in the root directory of the project with the following content:

```yaml
services:
  stationeers-server:
    container_name: stationeers-server
    build: .
    image: stationeers-server-ui:latest
    ports:
      - "8080:8080" # Only do this if you've secured the connection, see addendum
      - "27016:27016"
    volumes:
      - ./saves:/app/saves
      - ./config:/app/config
    environment:
      - STEAMCMD_DIR=/app/steamcmd
    restart: unless-stopped
    command: ["/app/StationeersServerControl"]
```

2. **Run Docker Compose**

  `docker compose up -d`

This command will start the Stationeers Dedicated Server Control in a Docker container.

3. *(Optional)* **Check docker compose log**

  `docker compose logs -f`

**CTRL+C** to escape out of this "view"

4. **First-Time Setup**

From here, simply follow the steps in the First-Time Setup section. Make sure your savegame obviously goes into whatever path was defined in `docker-compose.yml` (default: ./saves/)

Docker will mount this path into the container at runtime.

## Important Security Note

For security reasons, do not expose the UI directly to the internet without proper authentication mechanisms. The `8080` port should only be exposed if secured at the very least through a reverse proxy with authentication and HTTPS termination before considering using this image, except for maybe private networks. Ensure that you have appropriate security measures in place to protect the server UI.

## Important Notes

- **Server Updates:** Currently, only the stable branch is supported for updates via Discord commands.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## Acknowledgments

- **[JacksonTheMaster](https://github.com/JacksonTheMaster):** Developed with ❤️ and 💧 by J. Langisch.
- **[Sebastian - The Novice](https://github.com/TheNoviceProspect):** Additional code and docker implementation crafted with ✨ and 🛠️ by Sebastian (The Novice).
- **[Visual Studio Code](https://code.visualstudio.com/):** Powered by ⚡ and 🖥️ by Microsoft, the silent hero behind the scenes.
- **[Go](https://go.dev/):** Built with 🚀 and 🔧 by the Go programming language.
- **[RocketWerkz](https://rocketwerkz.com/):** Inspired by 🌌 and 🎮 by the creators of Stationeers.
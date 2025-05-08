# Project Zomboid Startup Parameters

This document provides a structured list of startup parameters for configuring and running the Project Zomboid server and client. Parameters are grouped into categories for easier navigation.

---

## **General Server Parameters**

| Parameter                  | Description                                                                 | Example                                   |
|----------------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| `-servername <Name>`       | Sets the internal server name. Affects save file names.                     | `-servername AnotherWorldSave`           |
| `-adminusername <Username>`| Sets a custom username for the default admin user.                          | `-adminusername BobTheAdmin75`           |
| `-adminpassword <Password>`| Sets the default admin password automatically, bypassing the prompt.        | `-adminpassword Some3ReallyLongPassword14`|
| `-ip <IPv4>`               | Forces the server to bind to a specific IP address.                         | `-ip 123.45.678.9`                       |
| `-port <Port>`             | Overrides the default port in the INI file.                                 | `-port 16261`                            |
| `-udpport <Port>`          | Overrides the UDP port in the INI file.                                     | `-udpport 16262`                         |
| `-steamvac <true/false>`   | Enables or disables Valve Anti-Cheat.                                       | `-steamvac true`                         |
| `-cachedir <Path>`         | Sets the absolute path for the game's cache directory.                      | `-cachedir="/home/user/zomboid_cache"`   |
| `-gui`                     | Launches the server GUI alongside the console. **(Unstable)**               | `-gui`                                   |
| `-statistic <Seconds>`     | Enables multiplayer statistics monitoring. Period in seconds.               | `-statistic 10`                          |

---

## **Logging and Debugging**

| Parameter                  | Description                                                                 | Example                                   |
|----------------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| `-debug`                   | Launches the server in debug mode.                                          | `-debug`                                 |
| `-debuglog=<Filters>`      | Enables specific filters in the console log. Comma-separated list.          | `-debuglog=All`                          |
|                            |                                                                             | `-debuglog=Network,Sound`                |
| `-disablelog=<Filters>`    | Disables specific filters in the console log. Comma-separated list.         | `-disablelog=All`                        |
|                            |                                                                             | `-disablelog=Network,Sound`              |

---

## **Memory and JVM Options**

| Parameter                  | Description                                                                 | Example                                   |
|----------------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| `-Xms<Integer>m`           | Sets the minimum memory allocated to the JVM.                               | `-Xms4096m`                              |
| `-Xmx<Integer>m`           | Sets the maximum memory allocated to the JVM.                               | `-Xmx8192m`                              |
| `-Dzomboid.steam=<1/0>`    | Disables Steam API integration.                                             | `-Dzomboid.steam=1`                      |
| `-Ddeployment.user.cachedir=<Path>` | Sets the game's cache directory (Linux only).                     | `-Ddeployment.user.cachedir="/path"`     |
| `-Dsoftreset`              | Forces the game to perform a soft reset. **(Currently broken)**             | `-Dsoftreset`                            |
| `-Ddebug`                  | Launches the game in debug mode.                                            | `-Ddebug`                                |

---

## **Client-Specific Parameters**

| Parameter                  | Description                                                                 | Example                                   |
|----------------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| `-safemode`                | Launches the game with reduced resolution and texture compression.          | `-safemode`                              |
| `-nosound`                 | Disables game audio.                                                        | `-nosound`                               |
| `-aitest`                  | Enables AI testing mode.                                                    | `-aitest`                                |
| `-novoip`                  | Disables in-game voice chat.                                                | `-novoip`                                |
| `-debugtranslation`        | Enables debug mode for translations.                                        | `-debugtranslation`                      |
| `-modfolders <Folders>`    | Controls mod load order and directories.                                    | `-modfolders workshop,steam,mods`        |
| `+connect <IPv4:Port>`     | Connects to a server directly. Equivalent to `-Dargs.server.connect`.       | `+connect 127.0.0.1:16261`               |
| `+password <Password>`     | Provides a server password. Equivalent to `-Dargs.server.password`.         | `+password ServersPassword`              |

---

## **Launcher Parameters**

| Parameter                  | Description                                                                 | Example                                   |
|----------------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| `-pzexeconfig <Config>`    | Overrides the default launcher config file.                                 | `-pzexeconfig ProjectZomboid64Custom.json`|
| `-pzexelog <LogName>`      | Stores logging output of the launcher.                                      | `-pzexelog ProjectZomboid64.log`         |

---

## **Coop Server Parameters**

| Parameter                  | Description                                                                 | Example                                   |
|----------------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| `-coop`                    | Runs a coop server instead of a dedicated server.                          | `-coop`                                  |

---

## **Examples**

### **Basic Server Setup**
```bash
./start-server.sh -servername MyServer -adminusername Admin -adminpassword SecurePass123 -port 16261 -steamvac true
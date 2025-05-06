# Environment Variables

This Docker image supports the following environment variables, allowing you to configure the server easily. These variables are converted into arguments for the server command.

---

## Administrator Settings
- **`ADMINUSERNAME`**: Sets the administrator username. Default: `admin`.
- **`ADMINPASSWORD`**: Sets or changes the admin password. **Mandatory** at first startup; the server will fail to start without it.  
  *Recommendation*: Remove this variable after the server starts to avoid exposing it in logs.

---

## Server Access
- **`PASSWORD`**: Sets or changes the server password. Optional.
- **`IP`**: Specifies the interface IP where the server will listen. Default: all interfaces.
- **`PORT`**: Sets the server port. Default: `16261`.
- **`STEAMPORT1` & `STEAMPORT2`**: Sets the two additional ports required for Steam to work. Likely UDP but may also be TCP.

---

## Server Configuration
- **`SERVERNAME`**: Sets the server name, allowing multiple server versions.  
  *Note*: Changing the name creates a new server data directory. Avoid spaces or special characters to prevent admin user issues.
- **`SERVERPRESET`**: Sets the default server preset. Default: `apocalypse`.  
  Allowed options: `Apocalypse`, `Beginner`, `Builder`, `FirstWeek`, `SixMonthsLater`, `Survival`, `Survivor`.
- **`SERVERPRESETREPLACE`**: Replaces the server preset with the one set by `SERVERPRESET`. Default: `false`.

---

## Performance and Debugging
- **`MEMORY`**: Specifies the amount of memory for the server JVM. Example: `2048m`. Default: `8096m`.
- **`DEBUG`**: Enables debug mode for the server.
- **`FORCEUPDATE`**: Forces a server update on every start. This process may be slow if the image is outdated.

---

## Mods and Workshop
- **`MODFOLDERS`**: Specifies mod folders to load game mods.  
  Allowed options: `workshop`, `steam`, `mods`. Separate options with commas (e.g., `workshop,steam,mods`).
- **`WORKSHOP_IDS`**: Semicolon-separated list of Workshop IDs to install on the server.
- **`MOD_IDS`**: Semicolon-separated list of Mod IDs to install on the server.

---

## Soft Reset
- **`SOFTRESET`**: Performs a soft reset on the server. Refer to the [Soft Reset Guide](soft-reset.md) for more details.

---

## Steam and Security
- **`NOSTEAM`**: Starts the server in NoSteam mode, allowing non-Steam users to connect.
- **`STEAMVAC`**: Enables or disables SteamVAC protection on the server.

---

## Data and Localization
- **`CACHEDIR`**: Specifies the folder where server data is stored.  
  Default: `/home/steam/Zomboid`.  
  *Recommendation*: Use a persistent volume to retain server state.
- **`LANG`**: Sets the container locale, used by the server to determine language. Example: `en_EN.UTF-8`.

---

## Notes
- Mods are installed on the **second server start**.
- Maps are added on the **third server start**, after mods are installed.

---

For additional details, refer to the [Project-Z Documentation](../README.md).
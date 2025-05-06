## Soft Reset

A soft reset performs the following tasks:

### What It Does
- Removes items from the ground.
- Removes items from containers and replaces them with new loot (including player-made containers).
- Removes corpses and zombified players.
- Resets zombies.
- Removes blood splatter.
- Resets building alarms.
- Resets the game clock:
  - Likely resets to **Day 1**, which would restore water and electricity (assuming server settings have them available on Day 1).
- **Does not affect**:
  - Player-made buildings.
  - Player inventories.

---

### Files to Remove
To perform a soft reset, remove the following files from the server's data folder:

- `zombie_X_Y.bin` (all files matching this pattern)
- `map_t.bin`
- `map_meta.bin`
- `reanimated.bin`

> **Note:** The equivalent files for the modern version of the server need to be confirmed.

---

### Known Issues
- Currently, the soft reset feature is **not working correctly**.
- Activating it causes the server to crash.
- The tasks listed above are **not performed**, so no changes occur on the server.

---

For further updates, refer to the official documentation or community forums.
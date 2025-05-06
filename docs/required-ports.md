## Required Ports

The required ports are documented in the [Official Wiki](https://pzwiki.net/wiki/Dedicated_Server#Forwarding_Required_Ports).  
Please note that these ports may change in the future.

---

### Steam Clients Ports

These ports are used by Steam clients to connect to the server. Ensure they are open in your firewall and properly configured in NAT:

- **8766 UDP**
- **8767 UDP**
- **16261 UDP** (configurable)

---

### Non-Steam Clients Ports

These ports are used by No-Steam clients to connect to the server. Ensure they are open in your firewall and properly configured in NAT:

- **8766 UDP**
- **8767 UDP**
- **16261 UDP** (configurable)
- **16262 - 16272 TCP** (range depends on the above port and the number of client slots)

---

For more details, refer to the [Official Wiki](https://pzwiki.net/wiki/Dedicated_Server#Forwarding_Required_Ports).
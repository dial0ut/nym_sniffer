# nym_sniffer

`nym_sniffer` is a command-line tool designed to provide a higher-level interface to `tcpdump`. It's primarily used for testing the Nym mixnet, but can be used for any purpose where packet sniffing might be necessary.

## Usage

```bash
nym_sniffer -i interface [-p ports] [-a address] [-r] [-c] [-f file]

Options:

-i Network interface to listen on (required)
-p Ports to listen on, separated by commas (optional)
-a IP address to filter by (optional)
-r Show raw packet data (optional)
-c Disable colorized output (optional, default is colored)
-f File to save output to (optional, .pcap for binary or .txt for text)

```

## Examples

```bash
# Sniff on the eth0 interface
nym_sniffer -i eth0

# Sniff on the eth0 interface on port




# Sniff on the eth0 interface on ports 80 and 443 for a specific IP
nym_sniffer -i eth0 -p 1789 -a 192.168.1.1

# Sniff on the eth0 interface and save output to a pcap file
nym_sniffer -i eth0 -f output.pcap

```

### Multiple ports and colors with `-p` flag don't work at this point. I got a little sidetracked again with COLORS ... ::

### Notes

Please note that nym_sniffer requires tcpdump to be installed and available in your PATH. It also requires root privileges for packet sniffing. Always be sure to use tools like this responsibly and ethically.)

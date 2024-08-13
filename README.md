```markdown
# ApacheVhostMaker

## Overview

**ApacheVhostMaker** is a script designed for creating and managing virtual hosts in XAMPP on macOS and Ubuntu. It simplifies the process of setting up virtual hosts and configuring your Apache server. This script is specifically tested and made for XAMPP environments.

## Features

- **Create Virtual Hosts**: Easily add new virtual hosts with customizable document roots.
- **Update /etc/hosts**: Automatically add entries for new virtual hosts.
- **Manage Apache**: Restart XAMPP and handle running Apache servers to avoid conflicts.

## Prerequisites

- XAMPP for macOS or Ubuntu installed.
- `sudo` privileges for modifying `/etc/hosts` and restarting XAMPP.
- Basic knowledge of terminal commands.

## Installation

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/mashiroalexis/ApacheVhostMaker.git
    cd ApacheVhostMaker
    ```

2. **Make the Script Executable**:

    ```bash
    chmod +x xampp-macos-vhost.sh
    ```

## Usage

To create a new virtual host, run the script with the following command:

```bash
sudo bash xampp-macos-vhost.sh sitename.domain [custom/path]
```

- `sitename.domain`: The domain name for your virtual host (e.g., `example.local`).
- `[custom/path]`: Optional custom path to append to the document root. Defaults to the base document root if not provided.

### Example

Create a virtual host for `webtest.org` with a custom path `/public`:

```bash
sudo bash xampp-macos-vhost.sh webtest.org /public
```

This command sets the document root to `/Applications/XAMPP/xamppfiles/htdocs/webtest.org/public` (on macOS) or `/opt/lampp/htdocs/webtest.org/public` (on Ubuntu) and adds the necessary configurations.

## Script Details

- **Create Necessary Directories**: Ensures the document root directory exists.
- **Set File Ownership and Permissions**: Configures appropriate permissions for the document root.
- **Add Virtual Host Configuration**: Updates the `httpd-vhosts.conf` file with the new virtual host settings.
- **Update /etc/hosts**: Adds an entry for the new virtual host domain.
- **Restart XAMPP**: Restarts XAMPP to apply changes and handles any existing Apache processes.

## Troubleshooting

- **Apache Not Starting**: Ensure no other web server is running on port 80. Use `lsof -i :80` to check.
- **Configuration Errors**: Review the configuration files and ensure there are no duplicate entries.

## Contributing

If you find bugs or wish to contribute improvements, please fork the repository and submit a pull request. Contributions are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please open an issue on the [GitHub repository](https://github.com/mashiroalexis/ApacheVhostMaker.git).
```
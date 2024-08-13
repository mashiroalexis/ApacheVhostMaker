# XAMPP Virtual Host Manager for macOS

## Overview

The XAMPP Virtual Host Manager is a bash script designed to automate the creation and management of virtual hosts in XAMPP for macOS. This script allows you to easily set up virtual hosts, update your `/etc/hosts` file, and manage Apache server configurations with minimal effort.

## Features

- **Create Virtual Hosts**: Set up virtual hosts in XAMPP with specified document roots.
- **Update /etc/hosts**: Automatically add entries for your virtual hosts.
- **Manage Apache**: Restart XAMPP if necessary, and handle running Apache servers to avoid conflicts.
- **Custom Paths**: Support for custom document root paths.

## Prerequisites

- XAMPP for macOS installed.
- sudo privileges to modify `/etc/hosts` and restart XAMPP.
- Basic understanding of using the terminal and bash scripting.

## Installation

1. **Clone the Repository** (or download the script directly):

    ```bash
    git clone https://github.com/your-username/xampp-virtual-host-manager.git
    cd xampp-virtual-host-manager
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

- `sitename.domain`: The domain name for your virtual host.
- `[custom/path]`: Optional custom path to append to the document root. If not provided, defaults to the base document root.

### Example

Create a virtual host for `webtest.org` with a custom path `/public`:

```bash
sudo bash xampp-macos-vhost.sh webtest.org /public
```

This will set the document root to `/Applications/XAMPP/xamppfiles/htdocs/webtest.org/public` and add the necessary configurations.

## Script Details

1. **Create Necessary Directories**: Ensures the document root directory exists.
2. **Set File Ownership and Permissions**: Configures appropriate permissions for the document root.
3. **Add Virtual Host Configuration**: Updates the `httpd-vhosts.conf` file with the new virtual host settings.
4. **Update /etc/hosts**: Adds an entry for the new virtual host domain.
5. **Restart XAMPP**: Restarts XAMPP to apply changes. Stops any existing Apache process if necessary.

## Troubleshooting

- **Apache Not Starting**: Ensure no other web server is running on port 80. Check if Apache is already running using `lsof -i :80`.
- **Configuration Errors**: If you encounter syntax errors, review the configuration files and ensure no duplicate entries exist.

## Contributing

If you find bugs or want to contribute improvements, please fork the repository and submit a pull request. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please open an issue on the [GitHub repository](https://github.com/your-username/xampp-virtual-host-manager).

---

Feel free to adjust the links and details as necessary to fit your specific repository and project setup.
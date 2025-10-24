#!/bin/bash
WSL_VSCODE_CONFIGURATOR_VERSION=0.1
CONFIG_FILE="$HOME/.local/bin/.nrf_extension_path"

EXTENSION_DIR=$(find ~/.vscode-server/extensions -name "nordic-semiconductor.nrf-connect-*-linux-x64" -type d | head -1)

if [ -z "$EXTENSION_DIR" ]; then
    echo "Can't find the extension folder"
    exit 1
fi

EXTENSION_CHANGED=false

if [ -f "$CONFIG_FILE" ]; then
    PREV_EXTENSION_DIR=$(cat "$CONFIG_FILE")

    if [ "$EXTENSION_DIR" != "$PREV_EXTENSION_DIR" ]; then
        echo "Extension directory changed! Proceeding with setup..."
        EXTENSION_CHANGED=true
    else
        if [ "${1:-}" = "reconfigure" ]; then
            EXTENSION_CHANGED=true
            echo "Reconfiguration ..."
        else
            echo "Configuration may have already been done..."
            exit 0
        fi
    fi
else
    echo "First run detected. Proceeding with setup..."
    EXTENSION_CHANGED=true
fi

if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi

if [ ! -f ~/.local/bin/nrfutil ]; then
    echo '#!/bin/bash' > ~/.local/bin/nrfutil
    echo "nrfutil.exe \$@" >> ~/.local/bin/nrfutil
    chmod a+x ~/.local/bin/nrfutil
    echo "Created nrfutil wrapper"
fi

if [ ! -f ~/.local/bin/nrfutil-device ]; then
    echo '#!/bin/bash' > ~/.local/bin/nrfutil-device
    echo "nrfutil-device.exe \$@" >> ~/.local/bin/nrfutil-device
    chmod a+x ~/.local/bin/nrfutil-device
    echo "Created nrfutil-device wrapper"
fi

NRFUTIL_DEVICE_PATH="$EXTENSION_DIR/platform/nrfutil/bin/nrfutil-device"
NRFUTIL_DEVICE_BACKUP="$EXTENSION_DIR/platform/nrfutil/bin/nrfutil-device.bak"

if [ -f "$NRFUTIL_DEVICE_PATH" ] && [ ! -f "$NRFUTIL_DEVICE_BACKUP" ]; then
    mv "$NRFUTIL_DEVICE_PATH" "$NRFUTIL_DEVICE_BACKUP"
elif [ -f "$NRFUTIL_DEVICE_PATH" ] && [ -f "$NRFUTIL_DEVICE_BACKUP" ]; then
    rm "$NRFUTIL_DEVICE_PATH"
fi

ln -s ~/.local/bin/nrfutil-device "$NRFUTIL_DEVICE_PATH"

# Configuring Windows settings
WIN_USERNAME=$(powershell.exe -c "echo \$env:USERNAME" | tr -d '\r')
WIN_HOME="/mnt/c/Users/$WIN_USERNAME"

if [ ! -f "$WIN_HOME/.nrfutil/bin/plugin-probe-worker.exe" ] && [ -f "$WIN_HOME/.nrfutil/lib/nrfutil-device/plugin-probe-worker.exe" ]; then
    echo "Copying plugin-probe-worker.exe..."
    cp "$WIN_HOME/.nrfutil/lib/nrfutil-device/plugin-probe-worker.exe" "$WIN_HOME/.nrfutil/bin/plugin-probe-worker.exe"
fi

# Updating Windows PATH
powershell.exe -Command "
\$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User');
\$newPath = 'C:\\Users\\$WIN_USERNAME\\.nrfutil\\bin';
if (\$userPath -notlike \"*\$newPath*\") {
    [Environment]::SetEnvironmentVariable('PATH', \"\$userPath;\$newPath\", 'User');
    Write-Host 'PATH updated successfully'
} else {
    Write-Host 'PATH already contains nrfutil path'
}"

echo "nRF Connect for WSL Setup completed successfully!"

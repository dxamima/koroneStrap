echo "\x1b[1;34mChecking permissions...\x1b[0m"
if [ "$EUID" -eq 0 ]; then
    echo "\x1b[1;31mDon't run as root!\x1b[0m"
    echo "\x1b[1;33mThis script should be run as a regular user for security reasons.\x1b[0m"
    exit 1
fi

echo "Running as user: $USER"
echo "\x1b[1;36mWelcome to the koroneStrap Init Script!\x1b[0m"
echo "\x1b[1;33mThis script will guide you through the initial setup of your koroneStrap environment.\x1b[0m"
echo "\x1b[1;37mDo you want to continue? (y/n): \x1b[0m"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "\x1b[1;32mContinuing with setup...\x1b[0m"
    echo "Installing homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo "\x1b[1;32m✓ homebrew installed successfully\x1b[0m"
    else
        echo "\x1b[1;31mERROR: Failed to install homebrew... Exiting...\x1b[0m"
        exit 1
    fi
        echo ""
    echo "\x1b[1;36mChoose Wine version to install:\x1b[0m"
    echo "\x1b[1;37m1) wine-stable \x1b[0m"
    echo "\x1b[1;37m2) wine@staging \x1b[0m"
    echo "\x1b[1;37mEnter your choice (1 or 2): \x1b[0m"
    read -r wine_choice

    wine_choice=${wine_choice:-1}
    
    case $wine_choice in
        1)
            echo "Installing wine (stable)..."
            if brew install wine-stable; then
                echo "\x1b[1;32m✓ wine installed successfully\x1b[0m"
            else
                echo "\x1b[1;31mERROR: Failed to install wine... Exiting...\x1b[0m"
                exit 1
            fi
            ;;
        2)
            echo "Installing wine@staging (development)..."
            if brew install wine@staging; then
                echo "\x1b[1;32m✓ wine@staging installed successfully\x1b[0m"
            else
                echo "\x1b[1;31mERROR: Failed to install wine@staging... Exiting...\x1b[0m"
                exit 1
            fi
            ;;
        *)
            echo "\x1b[1;31mInvalid choice. Defaulting to wine (stable)...\x1b[0m"
            if brew install wine; then
                echo "\x1b[1;32m✓ wine installed successfully\x1b[0m"
            else
                echo "\x1b[1;31mERROR: Failed to install wine... Exiting...\x1b[0m"
                exit 1
            fi
            ;;
    esac
    echo "Installing python3..."
    if brew install python3; then
        echo "\x1b[1;32m✓ python3 installed successfully\x1b[0m"
    else
        echo "\x1b[1;31mERROR: Failed to install python3... Exiting...\x1b[0m"
        exit 1
    fi
    echo ""
    echo "Installing colorama..."
    if pip3 install --user -r requirements.txt; then
        echo "\x1b[1;32m✓ packages installed successfully\x1b[0m"
    else
        echo "\x1b[1;31mERROR: Failed to install the required packages... Exiting...\x1b[0m"
        exit 1
    fi
    echo "Installing wine..."
    echo "\x1b[1;32mSetup completed successfully!\x1b[0m"
    echo "\x1b[1;37mDo you want to launch koroneStrap? (y/n): \x1b[0m"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Launching main script..."
        python3 koroneStrap.py
    else
        echo "\x1b[1;31mLaunching cancelled\x1b[0m"
    exit 0
fi
else
    echo "\x1b[1;31mSetup cancelled by user\x1b[0m"
    exit 0
fi

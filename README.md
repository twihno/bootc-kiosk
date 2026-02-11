# bootc-kiosk

A Fedora bootc-based kiosk container image with automatic GitHub Actions build.

## Overview

This repository provides a Fedora bootc container image designed for kiosk deployments. The image includes:
- Firefox browser configured for kiosk mode
- GNOME desktop environment with GDM display manager
- Automatic startup of kiosk application
- Multi-architecture support (amd64, arm64)

## Building the Image

### Manual Build

You can build the container image locally using Podman or Docker:

```bash
podman build -t bootc-kiosk:latest -f Containerfile .
```

### Automatic Build with GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds and pushes the container image to GitHub Container Registry (ghcr.io).

#### Triggering the Build

1. **Manual Dispatch**: Go to the "Actions" tab in GitHub, select "Build Bootc Container Image" workflow, and click "Run workflow". You can optionally specify a custom tag.

2. **Automatic on Push**: The workflow automatically triggers when changes are pushed to the `main` branch affecting the `Containerfile` or workflow file.

#### Accessing the Image

After a successful build, the image is available at:
```
ghcr.io/twihno/bootc-kiosk:latest
```

You can pull it using:
```bash
podman pull ghcr.io/twihno/bootc-kiosk:latest
```

## Using the Image

### Installing with bootc

To install this image as a bootable system:

```bash
# Install the bootc image
sudo bootc switch ghcr.io/twihno/bootc-kiosk:latest

# Reboot to apply changes
sudo systemctl reboot
```

### Customization

The default kiosk launches Firefox pointing to the Fedora Project website. To customize:

1. Modify the `/usr/local/bin/kiosk-start.sh` script in the Containerfile
2. Change the URL or application to launch
3. Rebuild and redeploy the image

## Architecture

- **Base Image**: `quay.io/fedora/fedora-bootc:41`
- **Display Manager**: GDM
- **Desktop Environment**: GNOME Shell
- **Browser**: Firefox (kiosk mode)
- **Default User**: kiosk (password: kiosk)

## License

This project configuration is provided as-is for kiosk deployments using Fedora bootc.

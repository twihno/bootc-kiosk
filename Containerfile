FROM quay.io/fedora/fedora-bootc:41

# Update system and install basic kiosk requirements
RUN dnf -y update && \
    dnf -y install \
        firefox \
        xorg-x11-server-Xorg \
        xorg-x11-xinit \
        xorg-x11-drivers \
        mesa-dri-drivers \
        gnome-session \
        gnome-shell \
        gdm \
        cage \
    && dnf clean all

# Enable graphical target and GDM
RUN systemctl set-default graphical.target && \
    systemctl enable gdm

# Add kiosk user (without sudo privileges for security)
RUN useradd -m kiosk && \
    echo "kiosk:kiosk" | chpasswd

# Create kiosk autostart configuration
RUN mkdir -p /home/kiosk/.config/autostart

# Create a simple kiosk startup script
RUN cat > /usr/local/bin/kiosk-start.sh << 'EOF'
#!/bin/bash
# Start Firefox in kiosk mode
firefox --kiosk https://www.fedoraproject.org
EOF

RUN chmod +x /usr/local/bin/kiosk-start.sh

# Create autostart entry for the kiosk
RUN cat > /home/kiosk/.config/autostart/kiosk.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Kiosk
Exec=/usr/local/bin/kiosk-start.sh
X-GNOME-Autostart-enabled=true
EOF

RUN chown -R kiosk:kiosk /home/kiosk/.config

# Set labels for container metadata
LABEL org.opencontainers.image.title="Fedora Bootc Kiosk"
LABEL org.opencontainers.image.description="A Fedora bootc-based kiosk container image"
LABEL org.opencontainers.image.source="https://github.com/twihno/bootc-kiosk"

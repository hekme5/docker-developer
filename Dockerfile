FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Install base prerequisites for repository keys
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    gnupg \
    && install -d -m 0755 /etc/apt/keyrings

# 1. Add Mozilla official APT repository for native Firefox (.deb without Snap)
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee /etc/apt/sources.list.d/mozilla.list > /dev/null && \
    printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n\nPackage: firefox*\nPin: release o=Ubuntu*\nPin-Priority: -1\n' > /etc/apt/preferences.d/mozilla

# 2. Add Microsoft APT repository for Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/packages.microsoft.gpg && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list

# Install core packages, XFCE desktop, Xvfb, VNC, noVNC, Firefox, VS Code, JDK, Python, and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    # System utilities & locales
    locales \
    sudo \
    git \
    nano \
    vim \
    net-tools \
    netcat-openbsd \
    supervisor \
    tar \
    # GUI Desktop & Display Server
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    dbus-x11 \
    xvfb \
    x11vnc \
    x11-utils \
    x11-xserver-utils \
    novnc \
    websockify \
    # GUI Applications (Firefox & VS Code)
    firefox \
    code \
    mousepad \
    # Graphics, fonts & library dependencies
    libfreetype6 \
    fontconfig \
    libxi6 \
    libxrender1 \
    libxtst6 \
    fonts-dejavu \
    fonts-freefont-ttf \
    fonts-liberation \
    # Python Environment
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-tk \
    python-is-python3 \
    build-essential \
    # Java Development Kit (OpenJDK)
    default-jdk \
    default-jre \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Wrap VS Code binary with --no-sandbox flag for container compatibility
RUN mv /usr/bin/code /usr/bin/code-real && \
    printf '#!/bin/bash\nexec /usr/bin/code-real --no-sandbox "$@"\n' > /usr/bin/code && \
    chmod +x /usr/bin/code

# Download and install IntelliJ IDEA Community (supports amd64 and arm64 natively)
RUN set -eux; \
    ARCH=$(uname -m); \
    if [ "$ARCH" = "x86_64" ]; then \
        IDEA_URL="https://download.jetbrains.com/product?code=IIC&latest&distribution=linux"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        IDEA_URL="https://download.jetbrains.com/product?code=IIC&latest&distribution=linuxARM64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi; \
    echo "Downloading IntelliJ IDEA from $IDEA_URL..."; \
    mkdir -p /opt/intellij /tmp/idea; \
    curl -fsSL -o /tmp/idea/idea.tar.gz "$IDEA_URL"; \
    tar -xzf /tmp/idea/idea.tar.gz -C /opt/intellij --strip-components=1; \
    rm -rf /tmp/idea; \
    ln -s /opt/intellij/bin/idea.sh /usr/local/bin/idea

# Set Java and IntelliJ environment variables
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="${JAVA_HOME}/bin:/opt/intellij/bin:${PATH}"

# Force software rendering for headless OpenGL / WebGL stability
ENV LIBGL_ALWAYS_SOFTWARE=1

# Allow pip to install packages globally inside container without PEP 668 warning
RUN mkdir -p /etc && \
    echo "[global]\nbreak-system-packages = true" > /etc/pip.conf

# Setup noVNC web interface default landing page
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Create non-root developer user with sudo privileges
RUN useradd -m -s /bin/bash -u 1000 -U developer && \
    echo "developer:developer" | chpasswd && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup IntelliJ desktop entry system-wide
RUN printf '[Desktop Entry]\nVersion=1.0\nType=Application\nName=IntelliJ IDEA Community\nComment=The Drive to Develop\nExec=/opt/intellij/bin/idea.sh %%f\nIcon=/opt/intellij/bin/idea.png\nTerminal=false\nCategories=Development;IDE;\nStartupWMClass=jetbrains-idea-ce\n' > /usr/share/applications/intellij.desktop

# Pre-configure XFCE default panel and create desktop shortcuts for Firefox, VS Code, and IntelliJ
RUN mkdir -p /home/developer/.config/xfce4/xfconf/xfce-perchannel-xml/ /home/developer/Desktop && \
    if [ -f /etc/xdg/xfce4/panel/default.xml ]; then \
      cp /etc/xdg/xfce4/panel/default.xml /home/developer/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml; \
    fi && \
    printf '[Desktop Entry]\nVersion=1.0\nType=Application\nName=Firefox Web Browser\nComment=Browse the World Wide Web\nExec=/usr/bin/firefox %%u\nIcon=firefox\nTerminal=false\nCategories=Network;WebBrowser;\n' > /home/developer/Desktop/firefox.desktop && \
    printf '[Desktop Entry]\nVersion=1.0\nType=Application\nName=Visual Studio Code\nComment=Code Editing. Redefined.\nExec=/usr/bin/code %%F\nIcon=vscode\nTerminal=false\nCategories=Development;IDE;\nStartupWMClass=Code\n' > /home/developer/Desktop/code.desktop && \
    printf '[Desktop Entry]\nVersion=1.0\nType=Application\nName=IntelliJ IDEA Community\nComment=The Drive to Develop\nExec=/opt/intellij/bin/idea.sh %%f\nIcon=/opt/intellij/bin/idea.png\nTerminal=false\nCategories=Development;IDE;\nStartupWMClass=jetbrains-idea-ce\n' > /home/developer/Desktop/intellij.desktop && \
    chmod +x /home/developer/Desktop/*.desktop && \
    chown -R developer:developer /home/developer/.config /home/developer/Desktop

# Copy startup scripts and supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/ /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/start-*.sh

# Default environment settings
ENV DISPLAY=:1
ENV RESOLUTION=1280x800x24
ENV VNC_PASSWORD=""

# Expose noVNC web port (6080) and VNC RFB port (5900)
EXPOSE 6080 5900

WORKDIR /home/developer/workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

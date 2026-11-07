# Ubuntu GUI Environment with JDK, Python, IntelliJ & VS Code in Docker

This project provides an Ubuntu environment equipped with:
- **GUI Desktop**: Lightweight XFCE4 desktop managed via Xvfb, x11vnc, and noVNC.
- **Development Tools**:
  - **Visual Studio Code**: Installed with `--no-sandbox` container wrapper.
  - **IntelliJ IDEA Community Edition**: Installed in `/opt/intellij`, with `idea` CLI symlink and desktop shortcut.
  - **Firefox**: Official native `.deb` package (non-Snap).
- **Python**: Python 3 with `pip`, `venv`, `build-essential`, and `python3-tk` (Tkinter).
- **Java**: OpenJDK (Java Development Kit & JRE) with `JAVA_HOME` preconfigured.
- **Access Methods**:
  - **Web Browser**: Connect instantly via HTML5 web interface at `http://localhost:6080`.
  - **Native VNC**: Connect via `localhost:5909` using TigerVNC, RealVNC, Apple Screen Sharing, etc.
- **Persistence**: `./workspace` directory is mounted directly to `/home/developer/workspace`.

---

## Quick Start

### 1. Build and Start the Container

```bash
docker compose up -d --build
```

### 2. Access the Desktop GUI

Choose either of the following connection methods:

#### A. Web Browser (Recommended)
Open your favorite browser and visit:
```
http://localhost:6080
```
- **Password**: `ubuntu` (configurable in `docker-compose.yml`)
- Direct auto-connect link: `http://localhost:6080/vnc.html?autoconnect=true&resize=remote`

#### B. Native VNC Client
Connect your VNC viewer (e.g., TigerVNC, RealVNC, or macOS Screen Sharing):
```
localhost:5909
```
- **Password**: `ubuntu`

---

## Launching IDEs & Browser

Inside the desktop GUI:
- **Desktop Shortcuts**: Double-click any of the icons on the desktop:
  - **Visual Studio Code**
  - **IntelliJ IDEA Community**
  - **Firefox Web Browser**
- **Application Menu**: Available under **Applications Menu → Development** (for VS Code & IntelliJ) and **Applications Menu → Internet** (for Firefox).
- **Terminal CLI**:
  - Open VS Code: `code .`
  - Open IntelliJ IDEA: `idea .`
  - Open Firefox: `firefox &`

---

## Testing Python & Java GUI Apps

Open **Terminal** from the desktop menu inside the container (or use `docker exec -it ubuntu-desktop bash`), navigate to `/home/developer/workspace`, and run:

### Test Python GUI (Tkinter)
```bash
python3 python_gui_demo.py
```
This opens an interactive Tkinter GUI window showing Python version details, an interactive counter, and message dialogs.

### Test Java Swing GUI
```bash
javac JavaGuiDemo.java
java JavaGuiDemo
```
This compiles and launches a Java Swing window showing JDK version, system details, and GUI controls.

---

## Configuration Options

In `docker-compose.yml`:

| Environment Variable | Default | Description |
|---|---|---|
| `RESOLUTION` | `1280x800x24` | Screen resolution in `WIDTHxHEIGHTxDEPTH` (e.g. `1920x1080x24`, `1600x900x24`) |
| `VNC_PASSWORD` | `ubuntu` | Password for web and VNC access. Leave empty `""` to disable password |

### Change Screen Resolution
To change the resolution, edit `docker-compose.yml`:
```yaml
environment:
  - RESOLUTION=1920x1080x24
```
Then restart the container:
```bash
docker compose up -d
```

### Accessing the Container Shell via CLI
```bash
docker exec -it ubuntu-desktop bash
```
User is `developer` with passwordless `sudo` rights.

---

## Stopping the Container

```bash
docker compose down
```
To stop and remove volumes:
```bash
docker compose down -v
```


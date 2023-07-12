## General setup (one time for the server)

Install podman: `sudo apt install podman` (I think)

Enable lingering for the current user: `sudo loginctl enable-linger $USER`

Create the directory for systemd user units: `mkdir -p ~/.config/systemd/user/`

## Setup

This only has to be done when initially deploying this project or if the deployment needs to be redone for some reason.

In most cases it should be enough to simply restart the service: `systemctl --user restart container-meeting-moderation-cards.service`

### Create the container

Make sure you are inside the directory with the config (the `.env` file).

```
podman run -d -v $(pwd)/.env:/app/.env:ro -p 8080:8080 --name meeting-moderation-cards ghcr.io/campus-consult/meeting-moderation-cards:latest
```

This starts the container in the background, you can verify it's running by using `podman ps`, a container with the name `meeting-moderation-cards` should exist and be in a running state.

Note: this will fail if the conatiner already exist.

### Create the service

Use podman to autogenerate the service files:

```
podman generate systemd --name meeting-moderation-cards --files
```

This should output `container-meeting-moderation-cards.service` in the current directory, view it with `cat container-meeting-moderation-cards.service` if you want.

Install the service file so that systemd can find it:

```
mv container-meeting-moderation-cards.service ~/.config/systemd/user/
```

Reload the systemd daemon so it knows about the new service

```
systemctl --user daemon-reload
```

## Managing the Service

Start it

```
systemctl --user start container-meeting-moderation-cards.service
```

Automatically make it start on server restart

```
systemctl --user enable container-meeting-moderation-cards.service
```

View the current status of the service

```
systemctl --user status container-meeting-moderation-cards.service
```

If you want to stop the service again, use:

```
systemctl --user stop container-meeting-moderation-cards.service
```

If you want to restart the service , use:

```
systemctl --user restart container-meeting-moderation-cards.service
```

To view the log messages of this service in the system log, use:

```
journalctl -xe --user-unit=container-meeting-moderation-cards
```

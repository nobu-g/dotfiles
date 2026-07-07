#!/usr/bin/env bash
# Install systemd *user* units under WSL, mirroring deploy/launch-agents.sh on
# macOS. This is best-effort: WSL only runs systemd when `[boot] systemd=true`
# is set in /etc/wsl.conf, so every step is guarded and the script always
# exits 0 so a systemd-less machine does not abort the wider deploy.
set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")
unit_dir="${HOME}/.config/systemd/user"

mkdir -p "${unit_dir}"
for f in "${here%/}"/systemd_units/*; do
  cp "${f}" "${unit_dir}/"
done

if ! command -v systemctl > /dev/null 2>&1; then
  echo "systemctl not found; skipping unit activation." >&2
  exit 0
fi
if ! systemctl --user show-environment > /dev/null 2>&1; then
  echo "systemd user instance unavailable; units copied but not enabled." >&2
  exit 0
fi

# Keep the user service running after logout so notifications keep flowing.
loginctl enable-linger "${USER}" > /dev/null 2>&1 || true

systemctl --user daemon-reload || true
systemctl --user enable --now code-server.service || true

exit 0

#!/usr/bin/env bash
# add-inotify-limits.sh
# Ensure inotify limits are set in /etc/sysctl.conf

set -euo pipefail

# Key-value pairs to add
declare -A INOTIFY_SETTINGS=(
  ["fs.inotify.max_user_watches"]="524288"
  ["fs.inotify.max_user_instances"]="512"
  ["fs.inotify.max_queued_events"]="65536"
)

SYSCTL_CONF="/etc/sysctl.conf"

echo "🔍 Checking and updating $SYSCTL_CONF..."

for KEY in "${!INOTIFY_SETTINGS[@]}"; do
  VALUE="${INOTIFY_SETTINGS[$KEY]}"
  
  if grep -qE "^${KEY}=" "$SYSCTL_CONF"; then
    echo "✅ $KEY already present — skipping"
  else
    echo "➕ Adding $KEY=$VALUE"
    echo "$KEY=$VALUE" | sudo tee -a "$SYSCTL_CONF" >/dev/null
  fi
done

echo "💡 Applying sysctl settings..."
sudo sysctl -p "$SYSCTL_CONF" >/dev/null

echo "✅ Done. Current inotify settings:"
sysctl fs.inotify.{max_user_watches,max_user_instances,max_queued_events}

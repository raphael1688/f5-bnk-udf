#!/bin/bash

# License status checker for f5-spk-cwc service
# Usage: ./license.sh status

if [[ "$1" == "status" ]]; then
    echo "CWC License Status:"
    echo "=================="
    
    # Get the latest license info
    LATEST_LOG=$(kubectl logs deployment/f5-spk-cwc -n f5-operators 2>/dev/null | grep "ResponseCM20LicenseVerified" | tail -1)
    
    if [[ -z "$LATEST_LOG" ]]; then
        echo "ERROR: Could not find license information in logs"
        exit 1
    fi
    
    # Extract license details
    ENTITLEMENT=$(echo "$LATEST_LOG" | grep -oP '"entitlement"="\K[^"]*')
    EXPIRY=$(echo "$LATEST_LOG" | grep -oP '"expiry"="\K[^"]*')
    UUID=$(echo "$LATEST_LOG" | grep -oP '"uuid"="\K[^"]*')
    
    echo "Status:      ✓ Licensed"
    echo "Entitlement: $ENTITLEMENT"
    echo "Expires:     $EXPIRY"
    echo "UUID:        $UUID"
else
    echo "Usage: $0 status"
    echo ""
    echo "Supported commands:"
    echo "  status   - Show CWC license status"
fi

#!/usr/bin/env bash

appUrlBase="http://127.0.0.1:8080"

readinessprobe_reply="$( curl -s ${appUrlBase}/api/readinessprobe )"
echo "readinessprobe_reply is ${readinessprobe_reply}"
if [ "${readinessprobe_reply}" != "ready" ]; then
  echo "ERROR: readinessprobe did not reply with \"ready\" but instead replied with: ${readinessprobe_reply}"
  exit 1
fi

ping_reply_expected="ping_20200204"
ping_reply="$( curl -s ${appUrlBase}/api/ping )"
echo "ping_reply is ${ping_reply}"
if [ "${ping_reply}" != "${ping_reply_expected}" ]; then
  echo "ERROR: ping did not reply with \"${ping_reply_expected}\" but instead replied with: ${ping_reply}"
  exit 1
fi

echo "LOCALDEV test script completed successfully."

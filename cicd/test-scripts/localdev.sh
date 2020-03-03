#!/usr/bin/env bash

appUrlBase="http://127.0.0.1:8080"

readinessprobe_reply_expected="ready"
readinessprobe_reply="$( curl -s ${appUrlBase}/api/readinessprobe )"
echo "readinessprobe_reply is ${readinessprobe_reply}"
if [ "${readinessprobe_reply}" != "${readinessprobe_reply_expected}" ]; then
  echo "ERROR: readinessprobe did not reply with \"${readinessprobe_reply_expected}\" but instead replied with: ${readinessprobe_reply}"
  exit 1
fi

echo "LOCALDEV test script completed successfully."

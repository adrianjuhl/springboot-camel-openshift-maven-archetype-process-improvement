#!/usr/bin/env bash

function usage
{
  echo "usage: dev.sh <options>"
  echo "where options are:"
  echo "    --application-name   applicationName    the application name"
  echo "    --namespace          namespace          the Openshift namespace hosting the application"
  echo "    --ocp-hostname-base  ocpHostnameBase    the OCP hostname base/suffix"
}

APPLICATION_NAME=
NAMESPACE=
OCP_HOSTNAME_BASE=

while [ "$1" != "" ]; do
  case $1 in
    --application-name )                shift
                                       APPLICATION_NAME=$1
                                       ;;
    --namespace )                      shift
                                       NAMESPACE=$1
                                       ;;
    --ocp-hostname-base )              shift
                                       OCP_HOSTNAME_BASE=$1
                                       ;;
    --help )                           usage
                                       exit
                                       ;;
    * )                                echo "Error: unknown option $1"
                                       usage
                                       exit 1
  esac
  shift
done

# Check that all options were provided
if [ -z "${APPLICATION_NAME}" ]; then
  echo "ERROR: option --application-name was not provided"
  usage
  exit 1
fi
if [ -z "${NAMESPACE}" ]; then
  echo "ERROR: option --namespace was not provided"
  usage
  exit 1
fi
if [ -z "${OCP_HOSTNAME_BASE}" ]; then
  echo "ERROR: option --ocp-hostname-base was not provided"
  usage
  exit 1
fi

echo "APPLICATION_NAME is ${APPLICATION_NAME}"
echo "NAMESPACE is ${NAMESPACE}"
echo "OCP_HOSTNAME_BASE is ${OCP_HOSTNAME_BASE}"

readinessprobe_reply_expected="ready"
readinessprobe_reply="$( curl -s https://${APPLICATION_NAME}-${NAMESPACE}.${OCP_HOSTNAME_BASE}/api/readinessprobe )"
echo "readinessprobe_reply is ${readinessprobe_reply}"
if [ "${readinessprobe_reply}" != "${readinessprobe_reply_expected}" ]; then
  echo "ERROR: readinessprobe did not reply with \"${readinessprobe_reply_expected}\" but instead replied with: ${readinessprobe_reply}"
  exit 1
fi

echo "DEV test script completed successfully."

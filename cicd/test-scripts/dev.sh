#!/usr/bin/env bash

function usage
{
  echo "usage: dev.sh <options>"
  echo "where options are:"
  echo "    --applicationName    applicationName    the application name"
  echo "    --namespace          namespace          the Openshift namespace hosting the application"
  echo "    --ocpHostnameBase    ocpHostnameBase    the OCP hostname base/suffix"
}

applicationName=
namespace=
ocpHostnameBase=

while [ "$1" != "" ]; do
  case $1 in
    --applicationName )                shift
                                       applicationName=$1
                                       ;;
    --namespace )                      shift
                                       namespace=$1
                                       ;;
    --ocpHostnameBase )                shift
                                       ocpHostnameBase=$1
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
if [ -z "$applicationName" ]; then
  echo "ERROR: option --applicationName was not provided"
  usage
  exit 1
fi
if [ -z "$namespace" ]; then
  echo "ERROR: option --namespace was not provided"
  usage
  exit 1
fi
if [ -z "$ocpHostnameBase" ]; then
  echo "ERROR: option --ocpHostnameBase was not provided"
  usage
  exit 1
fi

echo "applicationName is ${applicationName}"
echo "namespace is ${namespace}"
echo "ocpHostnameBase is ${ocpHostnameBase}"

readinessprobe_reply_expected="ready"
readinessprobe_reply="$( curl -s https://${applicationName}-${namespace}.${ocpHostnameBase}/api/readinessprobe )"
echo "readinessprobe_reply is ${readinessprobe_reply}"
if [ "${readinessprobe_reply}" != "${readinessprobe_reply_expected}" ]; then
  echo "ERROR: readinessprobe did not reply with \"${readinessprobe_reply_expected}\" but instead replied with: ${readinessprobe_reply}"
  exit 1
fi

echo "DEV test script completed successfully."

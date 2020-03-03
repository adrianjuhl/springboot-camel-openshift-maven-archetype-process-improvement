#!/usr/bin/env bash

function usage
{
  echo "usage: dev.sh <options>"
  echo "where options are:"
  echo "    --applicationName    applicationName    the application name"
  echo "    --namespace          namespace          the Openshift namespace hosting the application"
  echo "    --cluster            cluster            the openshift cluster: dev or prd"
}

applicationName=
namespace=
cluster=

while [ "$1" != "" ]; do
  case $1 in
    --applicationName )                shift
                                       applicationName=$1
                                       ;;
    --namespace )                      shift
                                       namespace=$1
                                       ;;
    --cluster )                        shift
                                       cluster=$1
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
if [ -z "$cluster" ]; then
  echo "ERROR: option --cluster was not provided"
  usage
  exit 1
fi

echo "applicationName is ${applicationName}"
echo "namespace is ${namespace}"
echo "cluster is ${cluster}"

openshiftHostnameBase=
if [ "${cluster}" == "dev" ]; then
  openshiftHostnameBase=openshift.development.adelaide.edu.au
fi
if [ "${cluster}" == "prd" ]; then
  openshiftHostnameBase=openshift.services.adelaide.edu.au
fi
if [ -z "${openshiftHostnameBase}" ]; then
  echo "ERROR: value of --cluster was not valid - valid values: dev, prd"
  usage
  exit 1
fi

readinessprobe_reply="$( curl -s https://${applicationName}-${namespace}.${openshiftHostnameBase}/api/readinessprobe )"
echo "readinessprobe_reply is ${readinessprobe_reply}"
if [ "${readinessprobe_reply}" != "ready" ]; then
  echo "ERROR: readinessprobe did not reply with \"ready\" but instead replied with: ${readinessprobe_reply}"
  exit 1
fi

ping_reply_expected="ping_20200204"
ping_reply="$( curl -s https://${applicationName}-${namespace}.${openshiftHostnameBase}/api/ping )"
echo "ping_reply is ${ping_reply}"
if [ "${ping_reply}" != "${ping_reply_expected}" ]; then
  echo "ERROR: ping did not reply with \"${ping_reply_expected}\" but instead replied with: ${ping_reply}"
  exit 1
fi

echo "DEV test script completed successfully."

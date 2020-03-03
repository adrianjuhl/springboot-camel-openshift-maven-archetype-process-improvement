#!/usr/bin/env bash

function usage
{
  echo "usage: deploy-kickstart-pipeline.sh <options>"
  echo "where options are:"
  echo "    --application-name               applicationName              the name to give the application"
  echo "    --source-repo-git-uri            sourceRepoGitUri             the URI of the source repository"
  echo "    --openshift-url                  openshiftUrl                 the URL of the OpenShift instance"
  echo "    --jenkins-build-namespace        jenkinsBuildNamespace        the namespace where jenkins builds occur"
  echo "    --image-registry-namespace       imageRegistryNamespace       the namespace where the built image is to be placed"
  echo "    --deployment-target-namespace    deploymentTargetNamespace    the namespace where the app will be deployed to"
  echo "    --ocp-hostname-base              ocpHostnameBase              the base/suffix of the OCP hostname"
  echo "    --dry-run                                                     only print out the resources to be applied"
}

APPLICATION_NAME=
SOURCE_REPO_GIT_URI=
OPENSHIFT_URL=
JENKINS_BUILD_NAMESPACE=
IMAGE_REGISTRY_NAMESPACE=
DEPLOYMENT_TARGET_NAMESPACE=
OCP_HOSTNAME_BASE=
DRY_RUN=FALSE

while [ "$1" != "" ]; do
  case $1 in
    --application-name )               shift
                                       APPLICATION_NAME=$1
                                       ;;
    --source-repo-git-uri )            shift
                                       SOURCE_REPO_GIT_URI=$1
                                       ;;
    --openshift-url )                  shift
                                       OPENSHIFT_URL=$1
                                       ;;
    --jenkins-build-namespace )        shift
                                       JENKINS_BUILD_NAMESPACE=$1
                                       ;;
    --image-registry-namespace )       shift
                                       IMAGE_REGISTRY_NAMESPACE=$1
                                       ;;
    --deployment-target-namespace )    shift
                                       DEPLOYMENT_TARGET_NAMESPACE=$1
                                       ;;
    --ocp-hostname-base )              shift
                                       OCP_HOSTNAME_BASE=$1
                                       ;;
    --dry-run )                        DRY_RUN=TRUE
                                       ;;
    * )                                echo "Error: unknown option $1"
                                       usage
                                       exit 1
  esac
  shift
done

# Check that all required options were provided
if [ -z "$APPLICATION_NAME" ]; then
  echo "ERROR: option --application-name was not provided"
  usage
  exit 1
fi
if [ -z "$SOURCE_REPO_GIT_URI" ]; then
  echo "ERROR: option --source-repo-git-uri was not provided"
  usage
  exit 1
fi
if [ -z "$OPENSHIFT_URL" ]; then
  echo "ERROR: option --openshift-url was not provided"
  usage
  exit 1
fi
if [ -z "$JENKINS_BUILD_NAMESPACE" ]; then
  echo "ERROR: option --jenkins-build-namespace was not provided"
  usage
  exit 1
fi
if [ -z "$IMAGE_REGISTRY_NAMESPACE" ]; then
  echo "ERROR: option --image-registry-namespace was not provided"
  usage
  exit 1
fi
if [ -z "$DEPLOYMENT_TARGET_NAMESPACE" ]; then
  echo "ERROR: option --deployment-target-namespace was not provided"
  usage
  exit 1
fi
if [ -z "${OCP_HOSTNAME_BASE}" ]; then
  echo "ERROR: option --ocp-hostname-base was not provided"
  usage
  exit 1
fi

IS_OC_LOGIN_VALID=`oc project | grep 'on server "'${OPENSHIFT_URL}'"' >/dev/null && echo 'TRUE'`

if [[ "$IS_OC_LOGIN_VALID" == "TRUE" ]]; then
  echo "OK - logged in to correct OpenShift instance ${OPENSHIFT_URL}"
else
  echo "ERROR - not logged in to ${OPENSHIFT_URL}"
  echo "Use 'oc login ${OPENSHIFT_URL}' to login to OpenShift"
  echo "Exiting"
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SOURCE_REPO_GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`

echo APPLICATION_NAME is ${APPLICATION_NAME}
echo SOURCE_REPO_GIT_URI is ${SOURCE_REPO_GIT_URI}
echo SOURCE_REPO_GIT_BRANCH is ${SOURCE_REPO_GIT_BRANCH}
echo SCRIPT_DIR is ${SCRIPT_DIR}
echo JENKINS_BUILD_NAMESPACE is ${JENKINS_BUILD_NAMESPACE}
echo IMAGE_REGISTRY_NAMESPACE is ${IMAGE_REGISTRY_NAMESPACE}
echo DEPLOYMENT_TARGET_NAMESPACE is ${DEPLOYMENT_TARGET_NAMESPACE}
echo OCP_HOSTNAME_BASE is ${OCP_HOSTNAME_BASE}

if [[ "$DRY_RUN" == "TRUE" ]]; then
  oc process \
      --filename ${SCRIPT_DIR}/kickstart-pipeline-template.yaml \
      --param=APPLICATION_NAME=${APPLICATION_NAME} \
      --param=SOURCE_REPO_GIT_URI=${SOURCE_REPO_GIT_URI} \
      --param=SOURCE_REPO_GIT_BRANCH=${SOURCE_REPO_GIT_BRANCH} \
      --param=CICD_RESOURCES_DIRECTORY=cicd \
      --param=JENKINS_BUILD_NAMESPACE=${JENKINS_BUILD_NAMESPACE} \
      --param=IMAGE_REGISTRY_NAMESPACE=${IMAGE_REGISTRY_NAMESPACE} \
      --param=DEPLOYMENT_TARGET_NAMESPACE=${DEPLOYMENT_TARGET_NAMESPACE} \
      --param=OCP_HOSTNAME_BASE=${OCP_HOSTNAME_BASE}
else
  oc process \
      --filename ${SCRIPT_DIR}/kickstart-pipeline-template.yaml \
      --param=APPLICATION_NAME=${APPLICATION_NAME} \
      --param=SOURCE_REPO_GIT_URI=${SOURCE_REPO_GIT_URI} \
      --param=SOURCE_REPO_GIT_BRANCH=${SOURCE_REPO_GIT_BRANCH} \
      --param=CICD_RESOURCES_DIRECTORY=cicd \
      --param=JENKINS_BUILD_NAMESPACE=${JENKINS_BUILD_NAMESPACE} \
      --param=IMAGE_REGISTRY_NAMESPACE=${IMAGE_REGISTRY_NAMESPACE} \
      --param=DEPLOYMENT_TARGET_NAMESPACE=${DEPLOYMENT_TARGET_NAMESPACE} \
      --param=OCP_HOSTNAME_BASE=${OCP_HOSTNAME_BASE} \
    | oc apply \
      --namespace=${JENKINS_BUILD_NAMESPACE} \
      --filename -
fi

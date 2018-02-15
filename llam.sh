#!/bin/bash

DEFAULT_PROFILE="${DEFAULT_PROFILE:-default}"

function list_lambdas () {
  # aws lambda list-functions --profile ${1} | jq -r '[.Functions[].FunctionName] | .[]' | sort
	aws lambda list-functions --profile ${1} --output text --query 'Functions[].[FunctionName]' | sort
}

function help_menu () {
cat << EOF
Usage: ${0} (-p [aws_profile_name])

ENVIRONMENT VARIABLES:
   DEFAULT_PROFILE  Default AWS profile to use. Default is 'default'

OPTIONS:
   -h|--help                 Show this message
   -p|--profile              AWS profile to use

EXAMPLES:
   List all the AWS Lambda functions in the given profile:
        $ llam -p tkt_prod_ro

   List all the AWS Lambda functions in the default profile:
        $ llam

NOTE:
   Requires aws cli and jq being installed.
EOF
}

if [[ $# == 0 ]]
then
	list_lambdas ${DEFAULT_PROFILE}
	exit 0
fi

while [[ $# > 0 ]]
do
case "${1}" in
  -p|--profile)
  list_lambdas "${2:-${DEFAULT_PROFILE}}"
  shift
  ;;
  -h|--help)
  help_menu
  shift
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  ;;
esac
shift
done
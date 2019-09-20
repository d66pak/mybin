#!/bin/bash

DEFAULT_PROFILE="${DEFAULT_PROFILE:-default}"


function encrypt_text () {
  aws kms encrypt --key-id ${1} --output text --query CiphertextBlob --plaintext ${2} --profile ${DEFAULT_PROFILE}
}

function help_menu () {
cat << EOF
Usage: ${0} (-k|--key-id [encryption_key_arn] -t|--text [text_to_encrypt])

ENVIRONMENT VARIABLES:
   DEFAULT_PROFILE  Default AWS profile to use. Default is 'default'

OPTIONS:
   -h|--help                 Show this message
   -p|--profile              AWS profile to use

EXAMPLES:
   Encrypt text using the given AWS profile:
        $ kms-encrypt -k 'arn:aws:kms:ap-southeast-2:1111111111:key/cfc7acf7-4f20-49c3-aa11-8be4cdc3291d' -t 'foobaz' -p tkt_prod_ro

   Encrypt text using default AWS profile:
        $ kms-encrypt --key-id 'arn:aws:kms:ap-southeast-2:1111111111:key/cfc7acf7-4f20-49c3-aa11-8be4cdc3291d' -t 'foobaz'

NOTE:
   Requires aws cli installed.
EOF
}

while [[ $# > 0 ]]
do
case "${1}" in
  -p|--profile)
  DEFAULT_PROFILE=${2:-${DEFAULT_PROFILE}}
  shift
  ;;
  -k|--key-id)
  KEY_ID=${2}
  shift
  ;;
  -t|--text)
  TEXT=${2}
  shift
  ;;
  -h|--help)
  help_menu
  shift
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  exit 1
  ;;
esac
shift
done

if [ "x$KEY_ID" = "x" ]
then
        echo "Key Id is missing!, try running: ${0} --help"
        exit 1
fi

if [ "x$TEXT" = "x" ]
then
        echo "Text to encrypt is missing!, try running: ${0} --help"
        exit 1
fi

encrypt_text ${KEY_ID} ${TEXT}

#!/bin/bash

DEFAULT_PROFILE="${DEFAULT_PROFILE:-default}"


function decrypt_text () {
  aws kms decrypt --ciphertext-blob fileb://<(echo ${1} | base64 -d) --query Plaintext --output text --profile ${DEFAULT_PROFILE} | base64 -d
}

function help_menu () {
cat << EOF
Usage: ${0} (-t|--text [base64_encoded_text_to_dencrypt])

ENVIRONMENT VARIABLES:
   DEFAULT_PROFILE  Default AWS profile to use. Default is 'default'

OPTIONS:
   -h|--help                 Show this message
   -p|--profile              AWS profile to use

EXAMPLES:
   Decrypt text using the given AWS profile:
        $ kms-dencrypt -t 'AQECAHgdopyHLruazml5TKrJJ29OMWqY467ikYT972uRC2itKgAAAGQwYgYJKo' -p tkt_prod_ro

   Decrypt text using default AWS profile:
        $ kms-dencrypt -t 'AQECAHgdopyHLruazml5TKrJJ29OMWqY467ikYT972uRC2itKgAAAGQwYgYJKo'

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

if [ "x$TEXT" = "x" ]
then
        echo "Text to encrypt is missing!, try running: ${0} --help"
        exit 1
fi

decrypt_text ${KEY_ID} ${TEXT}

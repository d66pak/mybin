#!/bin/bash

MAX_LINES=3000
SPLIT_PREFIX=ProductContent_
TEMP_OUTPUT_FILE=ProductContentTemp.csv
NO_HEADER_OUTPUT_FILE=ProductContent.csv
S3_DESTINATION=dev.au.productsearch-processor-input

echo "Executing stored procedure -> pw_wsp_ProductGetAll 'en', 3"
sqlcmd -Q "set nocount on; exec pw_wsp_ProductGetAll 'en', 3" -S sqlserver.dev.test -U user -P password -d Lotus -o ${TEMP_OUTPUT_FILE} -s"|" -W

if [ -f ${TEMP_OUTPUT_FILE} ]
then
	if [ -s ${TEMP_OUTPUT_FILE} ]
	then
		HEADER=$(head -1 ${TEMP_OUTPUT_FILE})
		sed '1,2d' ${TEMP_OUTPUT_FILE} > ${NO_HEADER_OUTPUT_FILE}
		SPLIT_OUT=$(split --verbose -d -l ${MAX_LINES} --additional-suffix="_$(date +'%F_%H-%M-%S').csv" ${NO_HEADER_OUTPUT_FILE} ${SPLIT_PREFIX})
		while IFS= read -r line
		do
                        file=$(echo ${line} | sed "s/.*'\(.*\)'/\1/g")
                        echo "Processing file: ${file}"
			sed -i "1i${HEADER}" ${file}
			aws s3 cp ${file} s3://${S3_DESTINATION}/
                        echo "Sleeping before uploading next file..."
			sleep 30s
                        rm -f ${file}
		done <<< "$SPLIT_OUT"
	else
		echo "ERROR: Nothing extracted from stored procedure"
	fi
else
	echo "ERROR: Nothing extracted from stored procedure"
fi

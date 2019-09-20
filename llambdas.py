import boto3

def llambdas(client):

	l_lambda = []
	kwargs = {}

	while 1:
		d_resp = client.list_functions(**kwargs)
		if 'Functions' in d_resp and d_resp['Functions']:
			l_lambda.extend(d_resp['Functions'])

		if 'NextMarker' in d_resp and d_resp['NextMarker']:
			kwargs['Marker'] = d_resp['NextMarker']
		else:
			break

	print 'Total lambda functions: ' + str(len(l_lambda))

	return l_lambda

import sys
import json
import boto3
import decimal

# Helper class to convert a DynamoDB item to JSON.
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

def main():
	key = sys.argv[1]
	table_name = sys.argv[2]
	aws_profile=sys.argv[3]

	item = boto3.session.Session(profile_name=aws_profile).resource('dynamodb').Table(table_name).get_item(Key={'lambda_name': key}).get('Item', {})
	print json.dumps(item, cls=DecimalEncoder)


if __name__ == '__main__':
	main()
from __future__ import unicode_literals
import json
import boto3
import datetime
from prompt_toolkit import prompt
from prompt_toolkit.history import FileHistory
from prompt_toolkit.auto_suggest import AutoSuggestFromHistory
from prompt_toolkit.contrib.completers import WordCompleter

from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import TerminalFormatter

import llambdas

def datetime_converter(o):
	if isinstance(o, datetime.datetime):
		return o.__str__()

def prettyPrintJson(d_dict):
	print(highlight(json.dumps(d_dict, indent=4, sort_keys=True, default=datetime_converter), JsonLexer(), TerminalFormatter()))

def main():
	# Get the AWS profile from user
	profileCompleter = WordCompleter(['default', 'tkt_prod_ro'], ignore_case=True)
	profile = prompt('AWS profile: ',
		history=FileHistory('profile-history.txt'),
		auto_suggest=AutoSuggestFromHistory(),
		completer=profileCompleter
		)

	# Create session and client
	session = boto3.session.Session(profile_name=profile)
	client = session.client('lambda')

	# Get the list of lambdas
	l_lambdas = llambdas.llambdas(client)
	l_lambdaName = [d_function['FunctionName'] for d_function in l_lambdas]

	lambdaCompleter = WordCompleter(l_lambdaName, ignore_case=True)
	lambdaName = prompt('Lambda name: ',
		history=FileHistory('lambda-history.txt'),
		auto_suggest=AutoSuggestFromHistory(),
		completer=lambdaCompleter
		)

	prettyPrintJson(filter(lambda d_function: d_function['FunctionName'] == lambdaName, l_lambdas))

	print ''
	print '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
	print ''
	# Event source mapping
	d_resp = client.list_event_source_mappings(FunctionName=lambdaName)
	prettyPrintJson(d_resp['EventSourceMappings'])


if __name__ == '__main__':
	main()

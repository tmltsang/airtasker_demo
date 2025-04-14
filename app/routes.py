from flask import Response
from app import app

@app.route('/')
def index():
    return Response(app.config.get('APP_NAME'), status=200, mimetype='text/plain')

@app.route('/healthcheck')
def healthcheck():
    return Response('OK', status=200, mimetype='text/plain')

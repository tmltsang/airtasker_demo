from flask import Response, Blueprint, current_app

routes = Blueprint('routes', __name__)

@routes.route('/')
def index():
    return Response(current_app.config.get('APP_NAME'), status=200, mimetype='text/plain')

@routes.route('/healthcheck')
def healthcheck():
    return Response('OK', status=200, mimetype='text/plain')

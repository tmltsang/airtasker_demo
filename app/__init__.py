from flask import Flask

def create_app():
    app = Flask(__name__)
    app.config.from_pyfile('settings.py')

    from app import routes
    app.register_blueprint(routes.routes)
    return app

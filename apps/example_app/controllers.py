from py4web import action

@action('')
@action.uses()
def index():
    return "¡Hola! Esta es una app de ejemplo en py4web corriendo en Docker con Caddy, MySQL y Fail2ban."

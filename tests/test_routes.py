
def test_index(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.mimetype == 'text/plain'
    assert response.text == 'airtasker'

def test_healthcheck(client):
    response = client.get('/healthcheck')
    assert response.status_code == 200
    assert response.mimetype == 'text/plain'
    assert response.text == 'OK'
from google.appengine.api import urlfetch
url = "http://twit-engine-mary.herokuapp.com/"
result = urlfetch.fetch(url=url,
                        method=urlfetch.GET,
                        headers={'Cache-Control':'max-age=0'},
                        deadline=10)
if result.status_code == 200:
    print result.content
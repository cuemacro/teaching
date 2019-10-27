from celery import Celery

app = Celery('celery_tasks', backend='redis://localhost', broker='redis://localhost')

# can also use celeryconfig object to configure, rather than including everything in the constructor
# app.config_from_object('celeryconfig')

@app.task
def add(x, y):
    return x + y
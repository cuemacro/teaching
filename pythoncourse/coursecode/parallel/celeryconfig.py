__author__ = 'saeedamen'  # Saeed Amen / saeed@cuemacro.com

BROKER_URL = 'redis://localhost'
CELERY_RESULT_BACKEND = 'redis://localhost'

# from kombu import serialization
# serialization.registry._decoders("application/x-python-serialize")

# the below should not need to be changed by nearly all users
CELERY_EVENT_SERIALIZER = 'json'
CELERY_ACCEPT_CONTENT = ['json'] #
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_HIJACK_ROOT_LOGGER = False
CELERY_STORE_ERRORS_EVEN_IF_IGNORED = True
CELERYD_MAX_TASKS_PER_CHILD = 50 # stop memory leaks, so restart workers after a 100 tasks
CELERY_ACKS_LATE = True
CELERY_TASK_RESULT_EXPIRES = 300 # clear memory after a while of results, if not picked up
# CELERY_ALWAYS_EAGER = True
BROKER_TRANSPORT_OPTIONS = {'socket_timeout': 300}
# BROKER_POOL_LIMIT = 0

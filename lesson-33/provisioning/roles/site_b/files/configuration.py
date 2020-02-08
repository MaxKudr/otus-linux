ALLOWED_HOSTS = ['127.0.0.1']

DATABASE = {
    'NAME': 'nb',
    'USER': 'nb',
    'PASSWORD': 'nb',
    'HOST': 'localhost',
    'PORT': '',
    'CONN_MAX_AGE': 300,
}

SECRET_KEY = '_kVQ+4C-SrvYbZNiLR7Wo3&cXPUd0D*n2Kzj9M%uyhwIa@ltxE'

REDIS = {
    'HOST': 'localhost',
    'PORT': 6379,
    'PASSWORD': '',
    'DATABASE': 0,
    'CACHE_DATABASE': 1,
    'DEFAULT_TIMEOUT': 300,
    'SSL': False,
}

ADMINS = [
]

BANNER_TOP = ''
BANNER_BOTTOM = ''
BANNER_LOGIN = ''

BASE_PATH = ''

CACHE_TIMEOUT = 900

CHANGELOG_RETENTION = 90

CORS_ORIGIN_ALLOW_ALL = False
CORS_ORIGIN_WHITELIST = [
]
CORS_ORIGIN_REGEX_WHITELIST = [
]

DEBUG = False

EMAIL = {
    'SERVER': 'localhost',
    'PORT': 25,
    'USERNAME': '',
    'PASSWORD': '',
    'TIMEOUT': 10,
    'FROM_EMAIL': '',
}

ENFORCE_GLOBAL_UNIQUE = False

EXEMPT_VIEW_PERMISSIONS = [
]

LOGGING = {}

LOGIN_REQUIRED = False
LOGIN_TIMEOUT = None

MAINTENANCE_MODE = False

MAX_PAGE_SIZE = 1000

METRICS_ENABLED = False

NAPALM_USERNAME = ''
NAPALM_PASSWORD = ''
NAPALM_TIMEOUT = 30
NAPALM_ARGS = {}

PAGINATE_COUNT = 50

PREFER_IPV4 = False

SESSION_FILE_PATH = None

TIME_ZONE = 'UTC'

WEBHOOKS_ENABLED = False

DATE_FORMAT = 'N j, Y'
SHORT_DATE_FORMAT = 'Y-m-d'
TIME_FORMAT = 'g:i a'
SHORT_TIME_FORMAT = 'H:i:s'
DATETIME_FORMAT = 'N j, Y g:i a'
SHORT_DATETIME_FORMAT = 'Y-m-d H:i'
import json
import os

from locust import HttpLocust, TaskSet, task

with open('config.json', 'r') as f:
    conf = json.load(f)

API_PATH = conf['api_path']
MIN_WAIT = conf['min_wait']
MAX_WAIT = conf['max_wait']
HOST = conf['host']

class UserBehavior(TaskSet):

    @task(1)
    def index(self):
        self.client.get(API_PATH)

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    host = HOST
    min_wait = int(MIN_WAIT)
    max_wait = int(MAX_WAIT)

import sys

sys.path.append('/var/www/myproject')

from myproject import application

if __name__ == "__main__":
    application.run()

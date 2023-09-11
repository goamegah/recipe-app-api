"""
Django commands to wait db for database to be available
"""
import time

from django.core.management.base import BaseCommand
# to connect to the database
from psycopg2 import OperationalError as Psycopg2Error
# handle op error for db
from django.db.utils import OperationalError


class Command(BaseCommand):
    """Django command to wait for database"""

    def handle(self, *args, **options):
        """Entrypoint for command."""
        self.stdout.write(msg='waiting for database')
        db_up = False
        while db_up is False:
            try:
                # check is a method of BaseCommand
                self.check(databases=['default'])
                db_up = True
            except (Psycopg2Error, OperationalError):
                self.stdout.write(
                    msg='Database unavalable waiting 1 second...')
                time.sleep(1)
        self.stdout.write(
            msg=self.style.SUCCESS('Database available!'))

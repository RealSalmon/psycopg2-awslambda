import time
import logging
import peewee


db = peewee.PostgresqlDatabase(None)


class GreatThing(peewee.Model):
    title = peewee.CharField()

    class Meta:
        database = db


def setup_function():
    db.init(
        'postgres',
        user='postgres',
        password=None,
        host='postgresql',
    )

    tries = 0
    while tries < 5:
        try:
            db.connect()
            if not GreatThing.table_exists():
                GreatThing.create_table(True)
            break
        except peewee.OperationalError as E:
            tries += 1
            time.sleep(5)
            logging.error(str(E))

    logging.error("Giving up on database connection!")


def teardown_function():
    GreatThing.drop_table()
    db.close()


def test_base():
    assert GreatThing.select().count() == 0


def test_insert():
    assert GreatThing.select().count() == 0
    GreatThing.create(title="hellacool")
    assert GreatThing.select().count() == 1


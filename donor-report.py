__author__ = 'Adam'
import sys
import sqlite3
from contextlib import closing
import jinja2

engine = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))

start_of_year = sys.argv[1]

# open the database connection
with closing(sqlite3.connect('charity.db')) as cxn:
    # next we need a cursor
    with closing(cxn.cursor()) as cur:
        # run a query
        cur.execute('''
                SELECT DISTINCT donor_name, donor_email
                From donor
                JOIN gift USING (donor_id)
                WHERE DATE (gift_date, 'start of year') = ?
                GROUP BY donor_name;
        ''', (start_of_year,))
        row = cur.fetchone()
        if row is None:
            print('Year {} does not exist'.format(start_of_year))
            sys.exit(1)

        # donor_id = row[0]

        # cur.execute('''
        #     SELECT DISTINCT donor_name, donor_email
        #     From donor
        #     JOIN gift USING (donor_id)
        #     WHERE DATE (gift_date, 'start of year') = '2012-01-01'
        #     GROUP BY donor_name;
        # ''', (donor_id,))
        # pubs = []
        # total = 0
        # for title, npapers in cur:
        #     pubs.append({'title': title, 'article_count': npapers})
        #     total += npapers

        template = engine.get_template('EOYreports.html')
        with open('{}.html'.format(start_of_year), 'w') as outf:
            print(template.render(donor_name='Fred', donor_id='25',),
                  file=outf)
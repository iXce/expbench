#!/usr/bin/env python

OUT_PATH = '/meleze/data0/public_html/gseguin/expcenter/index.html'

import sys
sys.path.append("/scratch/code/make_webpage")
import os

import psycopg2
import psycopg2.extras

from webpagemaker import WebpageMaker

BENCH_DIR = os.path.dirname(os.path.abspath(__file__))

# Load credentials
credsdata = open(os.path.join(BENCH_DIR, "db_creds.m")).read()
creds = {}
for line in credsdata.split(";"):
    if not line.strip(): continue
    bits = line.strip().split("=")
    creds[bits[0].strip()] = eval(bits[1])

conn = psycopg2.connect("dbname='%(db_database)s' user='%(db_user)s' host='%(db_host)s' password='%(db_password)s'" % creds)
cur = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
cur.execute("""SELECT * FROM experiments ORDER BY ID DESC""")
rows = cur.fetchall()
conn.close()

nrows = len(rows)

header = ['ID', 'Description', 'APT task', 'Status', 'Params', 'NRuns', 'Report']

def to_table_item(s):
    item = {}
    item['type'] = 'table'
    lines = s.split("\n")
    header = [x.strip() for x in lines[0].split("&")]
    item['header'] = header
    item['rows'] = []
    for line in lines[1:]:
        if not line.strip(): continue
        item['rows'].append([x.strip() for x in line.split("&")])
    return item

page = []
for row in rows:
    row_params = row['params'].strip().replace("\n", "<br />")
    row_created = row['created'].strftime("%Y-%m-%d %H:%M")
    row_updated = row['updated'].strftime("%Y-%m-%d %H:%M")
    if row['status'] == "Finished":
        row_status = "Created:<br />%s<br />Finished: <img src=\"imgs/extras/finished.png\" /><br />%s" % (row_created, row_updated)
    else:
        row_status = "Created:<br />%s<br />Running <img src=\"imgs/extras/running.gif\" />" % row_created
    row_report = row['report']
    if row_report.strip():
        row_report = to_table_item(row_report)
    row_desc = {"type": "text", "text": row['name']}
    if row['explink']: row_desc['link'] = row['explink']
    page_row = [row['id'], row_desc, row['apt_taskid'], row_status, row_params, row['nruns'], row_report]
    page.append(page_row)

data = {}
data['params'] = {
        'target': OUT_PATH,
        'target_dir': os.path.dirname(OUT_PATH),
        'title': 'Guillaume\'s experiments hub',
        'header': header,
        'extracss': """#maintable td, #maintable th {border: 1px solid #888; padding: 5px;} #maintable { margin-left: 10px; margin-right: 10px;}""",
        'extraimages': [os.path.join(BENCH_DIR, 'img', 'running.gif'),
                        os.path.join(BENCH_DIR, 'img', 'finished.png')
                       ]
    }

data['items'] = page

maker = WebpageMaker(data)
maker.make()

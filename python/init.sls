{% from 'python/map.jinja' import python with context %}

# There is a bug in the ubuntu pip package https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
# This command will run if pip is broken and install a version of pip that works!
pip-fixer:
  cmd.run:
    - name: 'python2.7 /tmp/get-pip.py'
    - unless: pip
    - require:
      - pkg: python-pip
      - file: pip-fixer
  file.managed:
    - name: /tmp/get-pip.py
    - mode: 700
    - source: salt://python/files/get-pip.py

install-virtualenv:
  pip.installed:
{% if python.virtualenv_version  %}
    - name: virtualenv=={{ python.virtualenv_version }}
{% else %}
    - name: virtualenv
{% endif %}
    - require:
      - cmd: pip-fixer

python-pip:
  pkg:
    - installed
    - require_in:
      - pip.*

python-dev:
  pkg:
    - installed
    - require_in:
      - pip.*

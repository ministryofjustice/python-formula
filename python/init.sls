{% from 'python/map.jinja' import python with context %}

# There is a bug in the ubuntu pip package https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
# This command will run if pip is broken and install a version of pip that works!
pip-fixer:
  cmd.run:
    - name: 'python2.7 /tmp/get-pip.py'
    - unless: pip
    - require:
      - file: pip-fixer
      - cmd: requests
  file.managed:
    - name: /tmp/get-pip.py
    - mode: 700
    - source: salt://python/files/get-pip.py

# We run this before the get-pip fix above to ensure it is broken here and not later. We have to use a cmd state
# because the pip state will return an error when it confirms the install of the package.
requests:
  cmd.run:
    - name: pip install requests==2.5.3
    - unless: pip list | grep "requests (2.5.3)"
    - require:
      - pkg: python-pip
      - pkg: python-dev

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

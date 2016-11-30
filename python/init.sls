{% from 'python/map.jinja' import python with context %}

# This command will install a local version of pip
pip-fixer:
  cmd.run:
    - name: "easy_install -U pip=={{ python.pip_version }} 'requests[security]==2.12.1'"
    - require_in:
      - pip.*
    - require:
      - pkg: libffi-dev
      - pkg: libssl-dev
    - reload_modules: true

install-virtualenv:
  pip.installed:
{% if python.virtualenv_version is defined %}
    - name: virtualenv=={{ python.virtualenv_version }}
{% else %}
    - name: virtualenv
{% endif %}

python-dev:
  pkg:
    - installed
    - require_in:
      - pip.*

libssl-dev:
  pkg.installed: []

libffi-dev:
  pkg.installed: []

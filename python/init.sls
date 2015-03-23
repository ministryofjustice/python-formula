{% from 'python/map.jinja' import python with context %}

install-virtualenv:
  pip.installed:
{% if python.virtualenv_version  %}
    - name: virtualenv=={{ python.virtualenv_version }}
{% else %}
    - name: virtualenv
{% endif %}
    - require:
      - pkg: python-pip

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

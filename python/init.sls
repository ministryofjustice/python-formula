{% from 'python/map.jinja' import python with context %}

# There is a bug in the ubuntu pip package https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
# This command will run if pip is broken and install a version of pip that works!
pip-fixer:
  cmd.run:
    - name: "easy_install -U pip 'requests[security]'"
    # Test that the current installed version of pip works when requests is
    # loaded. The python-pip shipped with ubuntu 14.04 doesn't work.
    - unless: >
        python -c "__requires__=['pip>=7.1.0', 'requests>=2.7.0']; import pkg_resources"
    - require_in:
      - pip.*
    - require:
      - pkg: libffi-dev
      - pkg: libssl-dev
    - reload_modules: true

install-virtualenv:
  pip.installed:
{% if python.virtualenv_version  %}
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

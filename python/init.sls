{% from 'python/map.jinja' import python with context %}

# There is a bug in the ubuntu pip package https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
# This command will run if pip is broken and install a version of pip that works!
pip-fixer:
  cmd.run:
{% if python.pip_version is defined %}
    - name: "easy_install -U pip=={{ python.pip_version }} 'requests[security]'"
{% else %}
    - name: "easy_install -U pip 'requests[security]'"
{% endif %}
    # Test that the current installed version of pip works when requests is loaded
    # Test that the installed version of pip has a project_name variable, Salt <=2015.8.5 is incompatible with Pip v8.1.2
    - unless:
       - python -c "import pip; pip.req.InstallRequirement.from_line('somereq').req.project_name; __requires__=['pip>=7.1.0', 'requests>=2.7.0']; import pkg_resources"
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

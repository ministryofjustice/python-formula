virtualenv:
  pip:
    - installed
    - require:
      - pkg: python-pip


python-pip:
  pkg:
    - installed
    - require_in:
      - pip.*


# virtualenv 1.11 does not work with system-site-packages
virtualenv==1.10.1:
  pip.installed:
    - require:
      - pkg: python-pip


python-dev:
  pkg:
    - installed
    - require_in:
      - pip.*

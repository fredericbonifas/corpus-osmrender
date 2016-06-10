{%- set pg = salt['mc_pgsql.settings']() %}
{%- set cfg = opts.ms_project %}
{%- import "makina-states/services/db/postgresql/hooks.sls" as hooks with context %}
{%- set orchestrate = hooks.orchestrate %}
{%- set data = cfg.data %}
include:
  - makina-states.services.db.postgresql.client

{{cfg.name}}-prereqs:
  pkg.latest:
    - pkgs:
      - libipc-sharelite-perl
      - debhelper
      - libgd-gd2-perl
      - libjson-perl
      - libgd3
      - libmapscript-perl
      - libmapserver2
      - devscripts
      - autoconf
      - automake
      - build-essential
      - bzip2
      - curl
      - cython
      - fonts-khmeros
      - fonts-sil-padauk
      - fonts-sipa-arundina
      - g++
      - gdal-bin
      - geoip-bin
      - gettext
      - git
      - groff
      - libbz2-dev
      - libdb-dev
      - libfreetype6-dev
      - libgdal1-dev
      - libgdbm-dev
      - libgeoip-dev
      - libgeos-dev
      - libopenjpeg-dev
      - libpq-dev
      - libreadline-dev
      - libsigc++-2.0-dev
      - libsqlite0-dev
      - libsqlite3-dev
      - libssl-dev
      - libtiff5
      - libtiff5-dev
      - libtool
      - libwebp5
      - libwebp-dev
      - libwww-perl
      - libxml2-dev
      - libxslt1-dev
      - m4
      - man-db
      - libmapnik-dev
      - libcurl4-gnutls-dev
      #- libcurl4-openssl-dev
      - mapnik-utils
      - node-carto
      - osm2pgsql
      - pkg-config
      - poppler-utils
      - python-dev
      - python-numpy
      - tcl8.4
      - tcl8.4-dev
      - tcl8.5
      - tcl8.5-dev
      - tk8.5-dev
      - ttf-dejavu
      {% if not pg.xenial_onward %}
      - ttf-indic-fonts-core
      - ttf-tamil-fonts
      - ttf-kannada-fonts
      - fonts-droid
      {% else %}
      - fonts-indic
      - fonts-knda
      - fonts-droid-fallback
      - fonts-taml
      {% endif %}
      - ttf-unifont
      - unzip
      - zlib1g-dev
    - require:
      - pkg: postgresql-pkgs-client
    - watch_in:
      - mc_proxy: {{orchestrate['base']['postbase']}}


buildosmconvert-{{cfg.name}}:
  cmd.run:
    - unless: test -e {{cfg.data_root}}/osmconvert
    - name: |
          wget -O - http://m.m.i24.cc/osmconvert.c | \
            cc -x c - -lz -O3 -o osmconvert
    - user: {{cfg.user}}
    - cwd: {{cfg.data_root}}
    - watch_in:
      - mc_proxy: {{orchestrate['base']['postbase']}}

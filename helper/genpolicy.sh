#!/bin/bash
venv=false
python3 -c 'import resoto_plugin_aws' > /dev/null 2>&1
if [ $? -ne 0 ]; then
    venv=venv-$RANDOM
    python3 -m venv "$venv"
    source "$venv/bin/activate"
    pip install resoto-plugin-aws
fi
pip install -r requirements.txt
python3 genpolicy.py > resoto-role.template
if [ "$venv" != false ]; then
    deactivate
    rm -rf "$venv"
fi

#!/usr/bin/env bash
venv=false
script_dir=$(dirname -- "${BASH_SOURCE[0]}")
python3 -c 'import resoto_plugin_aws' > /dev/null 2>&1
if [ $? -ne 0 ]; then
    venv="$script_dir/venv-$RANDOM"
    python3 -m venv "$venv"
    source "$venv/bin/activate"
    pip install resoto-plugin-aws
fi
pip install -r "$script_dir/requirements.txt"
python3 "$script_dir/genpolicy.py" "$script_dir/resoto-role.template.in" > resoto-role.template
if [ "$venv" != false ]; then
    deactivate
    rm -rf "$venv"
fi

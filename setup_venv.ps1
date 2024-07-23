python -m venv venv
./activate_venv.ps1
pip install -r .\requirements.txt
pip install --no-build-isolation --config-settings=editable.rebuild=true --config-settings=build-dir=build -v -e .
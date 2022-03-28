# Usage
Make sure to activate venv and install packages:
```
1. cd browser/extensions/extensibles/test/functional
2. python3 -m venv _virtualenv
3. source _virtualenv/bin/activate OR _virtualenv\Scripts\activate.bat
4. python3 -m pip install -r requirements.txt
```

Install geckodriver
```
* sudo port install geckodriver (with macports)
OR
* Download binary and place somewhere on PATH: https://github.com/mozilla/geckodriver/releases
```

Run the tests
**MacOS**
```
1. cd browser/extensions/extensibles/test/functional
2. python3 test_storehandler.py ../../../../../obj-x86_64-apple-darwin21.2.0/dist/Dokimi.app/Contents/MacOS/waterfox
```

**Linux**
```
1. cd browser/extensions/extensibles/test/functional
2. python3 test_storehandler.py ../../../../../obj-x86_64-pc-linux-gnu/dist/bin/waterfox
```

**Windows**
```
1. cd browser/extensions/extensibles/test/functional
2. python3 test_attribution.py ..\..\..\..\.. G4.0.8
```

Note: `test_attribution.py` must be run from a terminal (or cmd) with administrator access on Windows, otherwise an install/uninstall prompt will still appear.
    You also need to ensure that geckodriver is on PATH (add to mozilla-build/bin).
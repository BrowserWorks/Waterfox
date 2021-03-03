import sys
import os
import configparser
import hashlib
import subprocess
import shutil

# define functions
def parse_args():
    if len(sys.argv) == 2:
        return sys.argv[1]
    else:
        print("""Script usage:
        python3 prepare_release.py <objdir>""")
        sys.exit(1)

def parse_app_ini():
    config = configparser.ConfigParser()
    config.read(os.path.join('bin', 'application.ini'))
    return config

def extract_installer(browser_version):
    if 'mingw' in os.getcwd():
        path = os.path.join('install',
            'sea', f'Waterfox {browser_version} Setup.exe')
        cmd = f'7z x "{path}" -otmp/'
        subprocess.call(cmd, shell=True)
        return 'tmp'
    elif 'linux' in os.getcwd():
        cmd = f'tar -xvf waterfox-{browser_version}.en-US.linux-x86_64.tar.bz2'
        subprocess.call(cmd, shell=True)
        return 'waterfox'

def get_platform():
    cwd = os.getcwd()
    if 'mingw' in cwd:
        return 'win64'
    elif 'darwin' in cwd:
        return 'osx64'
    elif 'linux' in cwd:
        return 'linux64'

def copy_ancilliary():
    shutil.copy(
        os.path.join('..', '..', 'tools', 'update-packaging', 'make_full_update.sh'),
        'make_full_update.sh'
    )
    shutil.copy(
        os.path.join('..', '..', 'tools', 'update-packaging', 'common.sh'),
        'common.sh'      
    )

def generate_mar(platform, browser_version, channel):
    dirs = {
        'win64': os.path.join('tmp', 'core'),
        'osx64': os.path.join('waterfox', 'Waterfox.app'),
        'linux64': 'waterfox'
    }
    mar_loc = f'waterfox-{browser_version}.en-US.{platform}.complete.xz.mar'
    script_loc = './make_full_update.sh'
    cmd = f"MAR=host/bin/mar MOZ_PRODUCT_VERSION={browser_version} MAR_CHANNEL_ID={channel} {script_loc} {mar_loc} {dirs[platform]}"
    subprocess.call(cmd, shell=True)
    return mar_loc

def pull_vars(platform, config, mar_loc):
    var = {}
    var['BROWSER_VERSION'] = config['App']['DisplayVersion']
    var['PLATFORM64'] = platform
    var['VERSION'] = config['App']['Version']
    var['BUILDID'] = config['App']['BuildID']
    var['SHA512'] = get_hash(mar_loc)
    var['SIZE'] = str(os.path.getsize(mar_loc))
    return var

def get_hash(mar_loc):
    hasher = hashlib.sha512()
    with open(mar_loc, 'rb') as infile:
        buf = infile.read()
        hasher.update(buf)
    return hasher.hexdigest()

def iter_replace(string, mapping):
    for x in mapping.keys():
        string = string.replace(x, mapping[x])
    return string

def write_update_xml(xml):
    with open('update.xml', 'w') as outfile:
        outfile.writelines(xml)

def cleanup(clean_dir):
    if clean != None:
        shutil.rmtree(clean_dir)
    os.remove('make_full_update.sh')
    os.remove('common.sh')

def print_locales():
    sep = os.sep
    cur_dir = os.getcwd().split(sep)
    if cur_dir[-1] != 'Waterfox' and 'Waterfox' in cur_dir:
        idx = cur_dir.index('Waterfox')
        os.chdir(sep.join(cur_dir[:idx+1]))
    elif cur_dir[-1] == 'Waterfox':
        pass
    else:
        sys.exit('Not in a Waterfox directory')
    print(' '.join(os.listdir(os.path.join('browser','locales','l10n'))))


def main():
    # define update xml template
    update_xml = """<?xml version="1.0"?>
<updates>
    <update type="major" appVersion="VERSION"  buildID="BUILDID" detailsURL="https://www.waterfox.net/blog/waterfox-BROWSER_VERSION" displayVersion="BROWSER_VERSION" extensionVersion="VERSION" platformVersion="VERSION" version="VERSION">
        <patch type="complete" URL="https://waterfox.s3-us-west-2.amazonaws.com/testfiles/waterfox-BROWSER_VERSION.en-US.PLATFORM64.complete.xz.mar" hashFunction="SHA512" hashValue="HASH" size="SIZE"/>
    </update>
</updates>
"""
    test = 'https://cdn.waterfox.net/releases/PLATFORM64/update/waterfox-BROWSER_VERSION.en-US.PLATFORM64.complete.xz.mar'
    # parse args
    objdir = parse_args()
    os.chdir(os.path.join(objdir, 'dist'))
    config = parse_app_ini()
    display_version = config['App']['DisplayVersion']
    # extract
    platform = get_platform()
    clean_dir = extract_installer(config['App']['DisplayVersion'])
    # generate moz archive
    copy_ancilliary()
    mar_loc = generate_mar(platform, config['App']['DisplayVersion'], 'default')
    # generate update.xml
    var = pull_vars(platform, config, mar_loc)
    update_xml = iter_replace(update_xml, var)
    write_update_xml(update_xml)
    # clean up
    cleanup(clean_dir)

if __name__ == '__main__':
    main()

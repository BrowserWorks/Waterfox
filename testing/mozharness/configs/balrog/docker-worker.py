config = {
    'balrog_servers': [
        {
            'balrog_api_root': 'http://balrog/api',
            'ignore_failures': False,
            'url_replacements': [
                ('http://archive.mozilla.org/pub', 'http://download.cdn.mozilla.net/pub'),
            ],
            'balrog_usernames': {
                'firefox': 'ffxbld',
                'thunderbird': 'tbirdbld',
                'mobile': 'ffxbld',
                'Fennec': 'ffxbld',
            }
        }
    ]
}


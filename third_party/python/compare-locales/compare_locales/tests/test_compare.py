# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import
import unittest

from compare_locales import compare, paths


class TestTree(unittest.TestCase):
    '''Test the Tree utility class

    Tree value classes need to be in-place editable
    '''

    def test_empty_dict(self):
        tree = compare.Tree(dict)
        self.assertEqual(list(tree.getContent()), [])
        self.assertDictEqual(
            tree.toJSON(),
            {}
        )

    def test_disjoint_dict(self):
        tree = compare.Tree(dict)
        tree['one/entry']['leaf'] = 1
        tree['two/other']['leaf'] = 2
        self.assertEqual(
            list(tree.getContent()),
            [
                (0, 'key', ('one', 'entry')),
                (1, 'value', {'leaf': 1}),
                (0, 'key', ('two', 'other')),
                (1, 'value', {'leaf': 2})
            ]
        )
        self.assertDictEqual(
            tree.toJSON(),
            {
                'one/entry':
                    {'leaf': 1},
                'two/other':
                    {'leaf': 2}
            }
        )
        self.assertMultiLineEqual(
            str(tree),
            '''\
one/entry
    {'leaf': 1}
two/other
    {'leaf': 2}\
'''
        )

    def test_overlapping_dict(self):
        tree = compare.Tree(dict)
        tree['one/entry']['leaf'] = 1
        tree['one/other']['leaf'] = 2
        self.assertEqual(
            list(tree.getContent()),
            [
                (0, 'key', ('one',)),
                (1, 'key', ('entry',)),
                (2, 'value', {'leaf': 1}),
                (1, 'key', ('other',)),
                (2, 'value', {'leaf': 2})
            ]
        )
        self.assertDictEqual(
            tree.toJSON(),
            {
                'one': {
                    'entry':
                        {'leaf': 1},
                    'other':
                        {'leaf': 2}
                }
            }
        )


class TestObserver(unittest.TestCase):
    def test_simple(self):
        obs = compare.Observer()
        f = paths.File('/some/real/sub/path', 'de/sub/path', locale='de')
        obs.notify('missingEntity', f, 'one')
        obs.notify('missingEntity', f, 'two')
        obs.updateStats(f, {'missing': 15})
        self.assertDictEqual(obs.toJSON(), {
            'summary': {
                'de': {
                    'errors': 0,
                    'warnings': 0,
                    'missing': 15,
                    'missing_w': 0,
                    'report': 0,
                    'obsolete': 0,
                    'changed': 0,
                    'changed_w': 0,
                    'unchanged': 0,
                    'unchanged_w': 0,
                    'keys': 0,
                }
            },
            'details': {
                'de/sub/path':
                    [{'missingEntity': 'one'},
                     {'missingEntity': 'two'}]
            }
        })

    def test_module(self):
        obs = compare.Observer()
        f = paths.File('/some/real/sub/path', 'path',
                       module='sub', locale='de')
        obs.notify('missingEntity', f, 'one')
        obs.notify('obsoleteEntity', f, 'bar')
        obs.notify('missingEntity', f, 'two')
        obs.updateStats(f, {'missing': 15})
        self.assertDictEqual(obs.toJSON(), {
            'summary': {
                'de': {
                    'errors': 0,
                    'warnings': 0,
                    'missing': 15,
                    'missing_w': 0,
                    'report': 0,
                    'obsolete': 0,
                    'changed': 0,
                    'changed_w': 0,
                    'unchanged': 0,
                    'unchanged_w': 0,
                    'keys': 0,
                }
            },
            'details': {
                'de/sub/path':
                    [
                     {'missingEntity': 'one'},
                     {'obsoleteEntity': 'bar'},
                     {'missingEntity': 'two'},
                    ]
            }
        })


class TestAddRemove(unittest.TestCase):

    def _test(self, left, right, ref_actions):
        ar = compare.AddRemove()
        ar.set_left(left)
        ar.set_right(right)
        actions = list(ar)
        self.assertListEqual(actions, ref_actions)

    def test_equal(self):
        self._test(['z', 'a', 'p'], ['z', 'a', 'p'], [
                ('equal', 'z'),
                ('equal', 'a'),
                ('equal', 'p'),
            ])

    def test_add_start(self):
        self._test(['a', 'p'], ['z', 'a', 'p'], [
                ('add', 'z'),
                ('equal', 'a'),
                ('equal', 'p'),
            ])

    def test_add_middle(self):
        self._test(['z', 'p'], ['z', 'a', 'p'], [
                ('equal', 'z'),
                ('add', 'a'),
                ('equal', 'p'),
            ])

    def test_add_end(self):
        self._test(['z', 'a'], ['z', 'a', 'p'], [
                ('equal', 'z'),
                ('equal', 'a'),
                ('add', 'p'),
            ])

    def test_delete_start(self):
        self._test(['z', 'a', 'p'], ['a', 'p'], [
                ('delete', 'z'),
                ('equal', 'a'),
                ('equal', 'p'),
            ])

    def test_delete_middle(self):
        self._test(['z', 'a', 'p'], ['z', 'p'], [
                ('equal', 'z'),
                ('delete', 'a'),
                ('equal', 'p'),
            ])

    def test_delete_end(self):
        self._test(['z', 'a', 'p'], ['z', 'a'], [
                ('equal', 'z'),
                ('equal', 'a'),
                ('delete', 'p'),
            ])

    def test_replace_start(self):
        self._test(['b', 'a', 'p'], ['z', 'a', 'p'], [
                ('add', 'z'),
                ('delete', 'b'),
                ('equal', 'a'),
                ('equal', 'p'),
            ])

    def test_replace_middle(self):
        self._test(['z', 'b', 'p'], ['z', 'a', 'p'], [
                ('equal', 'z'),
                ('add', 'a'),
                ('delete', 'b'),
                ('equal', 'p'),
            ])

    def test_replace_end(self):
        self._test(['z', 'a', 'b'], ['z', 'a', 'p'], [
                ('equal', 'z'),
                ('equal', 'a'),
                ('add', 'p'),
                ('delete', 'b'),
            ])

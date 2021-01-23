/**
 * Copyright 2018 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module.exports.addTests = function({testRunner, expect, FFOX}) {
  const {describe, xdescribe, fdescribe, describe_fails_ffox} = testRunner;
  const {it, fit, xit} = testRunner;
  const {beforeAll, beforeEach, afterAll, afterEach} = testRunner;

  describe_fails_ffox('Accessibility', function() {
    it('should work', async function({page}) {
      await page.setContent(`
      <head>
        <title>Accessibility Test</title>
      </head>
      <body>
        <div>Hello World</div>
        <h1>Inputs</h1>
        <input placeholder="Empty input" autofocus />
        <input placeholder="readonly input" readonly />
        <input placeholder="disabled input" disabled />
        <input aria-label="Input with whitespace" value="  " />
        <input value="value only" />
        <input aria-placeholder="placeholder" value="and a value" />
        <div aria-hidden="true" id="desc">This is a description!</div>
        <input aria-placeholder="placeholder" value="and a value" aria-describedby="desc" />
        <select>
          <option>First Option</option>
          <option>Second Option</option>
        </select>
      </body>`);

      await page.focus('[placeholder="Empty input"]');
      const golden = FFOX ? {
        role: 'document',
        name: 'Accessibility Test',
        children: [
          {role: 'text leaf', name: 'Hello World'},
          {role: 'heading', name: 'Inputs', level: 1},
          {role: 'entry', name: 'Empty input', focused: true},
          {role: 'entry', name: 'readonly input', readonly: true},
          {role: 'entry', name: 'disabled input', disabled: true},
          {role: 'entry', name: 'Input with whitespace', value: '  '},
          {role: 'entry', name: '', value: 'value only'},
          {role: 'entry', name: '', value: 'and a value'}, // firefox doesn't use aria-placeholder for the name
          {role: 'entry', name: '', value: 'and a value', description: 'This is a description!'}, // and here
          {role: 'combobox', name: '', value: 'First Option', haspopup: true, children: [
            {role: 'combobox option', name: 'First Option', selected: true},
            {role: 'combobox option', name: 'Second Option'}]
          }]
      } : {
        role: 'WebArea',
        name: 'Accessibility Test',
        children: [
          {role: 'text', name: 'Hello World'},
          {role: 'heading', name: 'Inputs', level: 1},
          {role: 'textbox', name: 'Empty input', focused: true},
          {role: 'textbox', name: 'readonly input', readonly: true},
          {role: 'textbox', name: 'disabled input', disabled: true},
          {role: 'textbox', name: 'Input with whitespace', value: '  '},
          {role: 'textbox', name: '', value: 'value only'},
          {role: 'textbox', name: 'placeholder', value: 'and a value'},
          {role: 'textbox', name: 'placeholder', value: 'and a value', description: 'This is a description!'},
          {role: 'combobox', name: '', value: 'First Option', children: [
            {role: 'menuitem', name: 'First Option', selected: true},
            {role: 'menuitem', name: 'Second Option'}]
          }]
      };
      expect(await page.accessibility.snapshot()).toEqual(golden);
    });
    it('should report uninteresting nodes', async function({page}) {
      await page.setContent(`<textarea>hi</textarea>`);
      await page.focus('textarea');
      const golden = FFOX ? {
        role: 'entry',
        name: '',
        value: 'hi',
        focused: true,
        multiline: true,
        children: [{
          role: 'text leaf',
          name: 'hi'
        }]
      } : {
        role: 'textbox',
        name: '',
        value: 'hi',
        focused: true,
        multiline: true,
        children: [{
          role: 'generic',
          name: '',
          children: [{
            role: 'text', name: 'hi'
          }]
        }]
      };
      expect(findFocusedNode(await page.accessibility.snapshot({interestingOnly: false}))).toEqual(golden);
    });
    it('roledescription', async({page}) => {
      await page.setContent('<div tabIndex=-1 aria-roledescription="foo">Hi</div>');
      const snapshot = await page.accessibility.snapshot();
      expect(snapshot.children[0].roledescription).toEqual('foo');
    });
    it('orientation', async({page}) => {
      await page.setContent('<a href="" role="slider" aria-orientation="vertical">11</a>');
      const snapshot = await page.accessibility.snapshot();
      expect(snapshot.children[0].orientation).toEqual('vertical');
    });
    it('autocomplete', async({page}) => {
      await page.setContent('<input type="number" aria-autocomplete="list" />');
      const snapshot = await page.accessibility.snapshot();
      expect(snapshot.children[0].autocomplete).toEqual('list');
    });
    it('multiselectable', async({page}) => {
      await page.setContent('<div role="grid" tabIndex=-1 aria-multiselectable=true>hey</div>');
      const snapshot = await page.accessibility.snapshot();
      expect(snapshot.children[0].multiselectable).toEqual(true);
    });
    it('keyshortcuts', async({page}) => {
      await page.setContent('<div role="grid" tabIndex=-1 aria-keyshortcuts="foo">hey</div>');
      const snapshot = await page.accessibility.snapshot();
      expect(snapshot.children[0].keyshortcuts).toEqual('foo');
    });
    describe('filtering children of leaf nodes', function() {
      it('should not report text nodes inside controls', async function({page}) {
        await page.setContent(`
        <div role="tablist">
          <div role="tab" aria-selected="true"><b>Tab1</b></div>
          <div role="tab">Tab2</div>
        </div>`);
        const golden = FFOX ? {
          role: 'document',
          name: '',
          children: [{
            role: 'pagetab',
            name: 'Tab1',
            selected: true
          }, {
            role: 'pagetab',
            name: 'Tab2'
          }]
        } : {
          role: 'WebArea',
          name: '',
          children: [{
            role: 'tab',
            name: 'Tab1',
            selected: true
          }, {
            role: 'tab',
            name: 'Tab2'
          }]
        };
        expect(await page.accessibility.snapshot()).toEqual(golden);
      });
      it('rich text editable fields should have children', async function({page}) {
        await page.setContent(`
        <div contenteditable="true">
          Edit this image: <img src="fakeimage.png" alt="my fake image">
        </div>`);
        const golden = FFOX ? {
          role: 'section',
          name: '',
          children: [{
            role: 'text leaf',
            name: 'Edit this image: '
          }, {
            role: 'text',
            name: 'my fake image'
          }]
        } : {
          role: 'generic',
          name: '',
          value: 'Edit this image: ',
          children: [{
            role: 'text',
            name: 'Edit this image:'
          }, {
            role: 'img',
            name: 'my fake image'
          }]
        };
        const snapshot = await page.accessibility.snapshot();
        expect(snapshot.children[0]).toEqual(golden);
      });
      it('rich text editable fields with role should have children', async function({page}) {
        await page.setContent(`
        <div contenteditable="true" role='textbox'>
          Edit this image: <img src="fakeimage.png" alt="my fake image">
        </div>`);
        const golden = FFOX ? {
          role: 'entry',
          name: '',
          value: 'Edit this image: my fake image',
          children: [{
            role: 'text',
            name: 'my fake image'
          }]
        } : {
          role: 'textbox',
          name: '',
          value: 'Edit this image: ',
          children: [{
            role: 'text',
            name: 'Edit this image:'
          }, {
            role: 'img',
            name: 'my fake image'
          }]
        };
        const snapshot = await page.accessibility.snapshot();
        expect(snapshot.children[0]).toEqual(golden);
      });
      // Firefox does not support contenteditable="plaintext-only".
      !FFOX && describe('plaintext contenteditable', function() {
        it('plain text field with role should not have children', async function({page}) {
          await page.setContent(`
          <div contenteditable="plaintext-only" role='textbox'>Edit this image:<img src="fakeimage.png" alt="my fake image"></div>`);
          const snapshot = await page.accessibility.snapshot();
          expect(snapshot.children[0]).toEqual({
            role: 'textbox',
            name: '',
            value: 'Edit this image:'
          });
        });
        it('plain text field without role should not have content', async function({page}) {
          await page.setContent(`
          <div contenteditable="plaintext-only">Edit this image:<img src="fakeimage.png" alt="my fake image"></div>`);
          const snapshot = await page.accessibility.snapshot();
          expect(snapshot.children[0]).toEqual({
            role: 'generic',
            name: ''
          });
        });
        it('plain text field with tabindex and without role should not have content', async function({page}) {
          await page.setContent(`
          <div contenteditable="plaintext-only" tabIndex=0>Edit this image:<img src="fakeimage.png" alt="my fake image"></div>`);
          const snapshot = await page.accessibility.snapshot();
          expect(snapshot.children[0]).toEqual({
            role: 'generic',
            name: ''
          });
        });
      });
      it('non editable textbox with role and tabIndex and label should not have children', async function({page}) {
        await page.setContent(`
        <div role="textbox" tabIndex=0 aria-checked="true" aria-label="my favorite textbox">
          this is the inner content
          <img alt="yo" src="fakeimg.png">
        </div>`);
        const golden = FFOX ? {
          role: 'entry',
          name: 'my favorite textbox',
          value: 'this is the inner content yo'
        } : {
          role: 'textbox',
          name: 'my favorite textbox',
          value: 'this is the inner content '
        };
        const snapshot = await page.accessibility.snapshot();
        expect(snapshot.children[0]).toEqual(golden);
      });
      it('checkbox with and tabIndex and label should not have children', async function({page}) {
        await page.setContent(`
        <div role="checkbox" tabIndex=0 aria-checked="true" aria-label="my favorite checkbox">
          this is the inner content
          <img alt="yo" src="fakeimg.png">
        </div>`);
        const golden = FFOX ? {
          role: 'checkbutton',
          name: 'my favorite checkbox',
          checked: true
        } : {
          role: 'checkbox',
          name: 'my favorite checkbox',
          checked: true
        };
        const snapshot = await page.accessibility.snapshot();
        expect(snapshot.children[0]).toEqual(golden);
      });
      it('checkbox without label should not have children', async function({page}) {
        await page.setContent(`
        <div role="checkbox" aria-checked="true">
          this is the inner content
          <img alt="yo" src="fakeimg.png">
        </div>`);
        const golden = FFOX ? {
          role: 'checkbutton',
          name: 'this is the inner content yo',
          checked: true
        } : {
          role: 'checkbox',
          name: 'this is the inner content yo',
          checked: true
        };
        const snapshot = await page.accessibility.snapshot();
        expect(snapshot.children[0]).toEqual(golden);
      });

      describe('root option', function() {
        it('should work a button', async({page}) => {
          await page.setContent(`<button>My Button</button>`);

          const button = await page.$('button');
          expect(await page.accessibility.snapshot({root: button})).toEqual({
            role: 'button',
            name: 'My Button'
          });
        });
        it('should work an input', async({page}) => {
          await page.setContent(`<input title="My Input" value="My Value">`);

          const input = await page.$('input');
          expect(await page.accessibility.snapshot({root: input})).toEqual({
            role: 'textbox',
            name: 'My Input',
            value: 'My Value'
          });
        });
        it('should work a menu', async({page}) => {
          await page.setContent(`
            <div role="menu" title="My Menu">
              <div role="menuitem">First Item</div>
              <div role="menuitem">Second Item</div>
              <div role="menuitem">Third Item</div>
            </div>
          `);

          const menu = await page.$('div[role="menu"]');
          expect(await page.accessibility.snapshot({root: menu})).toEqual({
            role: 'menu',
            name: 'My Menu',
            children:
            [ { role: 'menuitem', name: 'First Item' },
              { role: 'menuitem', name: 'Second Item' },
              { role: 'menuitem', name: 'Third Item' } ]
          });
        });
        it('should return null when the element is no longer in DOM', async({page}) => {
          await page.setContent(`<button>My Button</button>`);
          const button = await page.$('button');
          await page.$eval('button', button => button.remove());
          expect(await page.accessibility.snapshot({root: button})).toEqual(null);
        });
        it('should support the interestingOnly option', async({page}) => {
          await page.setContent(`<div><button>My Button</button></div>`);
          const div = await page.$('div');
          expect(await page.accessibility.snapshot({root: div})).toEqual(null);
          expect(await page.accessibility.snapshot({root: div, interestingOnly: false})).toEqual({
            role: 'generic',
            name: '',
            children: [
              {
                role: 'button',
                name: 'My Button',
                children: [
                  { role: 'text', name: 'My Button' },
                ],
              },
            ],
          });
        });
      });
    });
    function findFocusedNode(node) {
      if (node.focused)
        return node;
      for (const child of node.children || []) {
        const focusedChild = findFocusedNode(child);
        if (focusedChild)
          return focusedChild;
      }
      return null;
    }
  });
};

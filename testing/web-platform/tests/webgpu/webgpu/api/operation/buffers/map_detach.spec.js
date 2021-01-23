/**
* AUTO-GENERATED - DO NOT EDIT. Source: https://github.com/gpuweb/cts
**/

export const description = '';
import { makeTestGroup } from '../../../../common/framework/test_group.js';
import { GPUTest } from '../../../gpu_test.js';

class F extends GPUTest {
  checkDetach(buffer, arrayBuffer, unmap, destroy) {
    const view = new Uint8Array(arrayBuffer);
    this.expect(arrayBuffer.byteLength === 4);
    this.expect(view.length === 4);
    if (unmap) buffer.unmap();
    if (destroy) buffer.destroy();
    this.expect(arrayBuffer.byteLength === 0, 'ArrayBuffer should be detached');
    this.expect(view.byteLength === 0, 'ArrayBufferView should be detached');
  }

}

export const g = makeTestGroup(F);
g.test('mapWriteAsync').params([{
  unmap: true,
  destroy: false
}, //
{
  unmap: false,
  destroy: true
}, {
  unmap: true,
  destroy: true
}]).fn(async t => {
  const buffer = t.device.createBuffer({
    size: 4,
    usage: GPUBufferUsage.MAP_WRITE
  });
  const arrayBuffer = await buffer.mapWriteAsync();
  t.checkDetach(buffer, arrayBuffer, t.params.unmap, t.params.destroy);
});
g.test('mapReadAsync').params([{
  unmap: true,
  destroy: false
}, //
{
  unmap: false,
  destroy: true
}, {
  unmap: true,
  destroy: true
}]).fn(async t => {
  const buffer = t.device.createBuffer({
    size: 4,
    usage: GPUBufferUsage.MAP_READ
  });
  const arrayBuffer = await buffer.mapReadAsync();
  t.checkDetach(buffer, arrayBuffer, t.params.unmap, t.params.destroy);
});
g.test('create_mapped').params([{
  unmap: true,
  destroy: false
}, {
  unmap: false,
  destroy: true
}, {
  unmap: true,
  destroy: true
}]).fn(async t => {
  const desc = {
    size: 4,
    usage: GPUBufferUsage.MAP_WRITE
  };
  const [buffer, arrayBuffer] = t.device.createBufferMapped(desc);
  const view = new Uint8Array(arrayBuffer);
  t.expect(arrayBuffer.byteLength === 4);
  t.expect(view.length === 4);
  if (t.params.unmap) buffer.unmap();
  if (t.params.destroy) buffer.destroy();
  t.expect(arrayBuffer.byteLength === 0, 'ArrayBuffer should be detached');
  t.expect(view.byteLength === 0, 'ArrayBufferView should be detached');
});
//# sourceMappingURL=map_detach.spec.js.map
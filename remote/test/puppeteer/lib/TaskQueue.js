class TaskQueue {
  constructor() {
    this._chain = Promise.resolve();
  }

  /**
   * @param {Function} task
   * @return {!Promise}
   */
  postTask(task) {
    const result = this._chain.then(task);
    this._chain = result.catch(() => {});
    return result;
  }
}

module.exports = {TaskQueue};
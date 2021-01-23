WebGLUtil = (function() {
  // ---------------------------------------------------------------------------
  // Error handling (for obvious failures, such as invalid element ids)

  function defaultErrorFunc(str) {
    console.log("Error: " + str);
  }

  var gErrorFunc = defaultErrorFunc;
  function setErrorFunc(func) {
    gErrorFunc = func;
  }

  function error(str) {
    gErrorFunc(str);
  }

  // ---------------------------------------------------------------------------
  // Warning handling (for failures that may be intentional)

  function defaultWarningFunc(str) {
    console.log("Warning: " + str);
  }

  var gWarningFunc = defaultWarningFunc;
  function setWarningFunc(func) {
    gWarningFunc = func;
  }

  function warning(str) {
    gWarningFunc(str);
  }

  // ---------------------------------------------------------------------------
  // WebGL helpers

  function getWebGL(canvasId, requireConformant, attributes) {
    // `requireConformant` will default to falsey if it is not supplied.

    var canvas = document.getElementById(canvasId);

    var gl = null;
    try {
      gl = canvas.getContext("webgl", attributes);
    } catch (e) {}

    if (!gl && !requireConformant) {
      try {
        gl = canvas.getContext("experimental-webgl", attributes);
      } catch (e) {}
    }

    if (!gl) {
      error("WebGL context could not be retrieved from '" + canvasId + "'.");
      return null;
    }

    return gl;
  }

  function withWebGL2(canvasId, callback, onFinished) {
    var run = function() {
      var canvas = document.getElementById(canvasId);

      var gl = null;
      try {
        gl = canvas.getContext("webgl2");
      } catch (e) {}

      if (!gl) {
        todo(false, "WebGL2 is not supported");
        onFinished();
        return;
      }

      function errorFunc(str) {
        ok(false, "Error: " + str);
      }
      setErrorFunc(errorFunc);
      setWarningFunc(errorFunc);

      callback(gl);
      onFinished();
    };

    try {
      var prefArrArr = [
        ["webgl.force-enabled", true],
        ["webgl.enable-webgl2", true],
      ];
      var prefEnv = { set: prefArrArr };
      SpecialPowers.pushPrefEnv(prefEnv, run);
    } catch (e) {
      warning("No SpecialPowers, but trying WebGL2 anyway...");
      run();
    }
  }

  function getContentFromElem(elem) {
    var str = "";
    var k = elem.firstChild;
    while (k) {
      if (k.nodeType == 3) {
        str += k.textContent;
      }

      k = k.nextSibling;
    }

    return str;
  }

  // Returns a valid shader, or null on errors.
  function createShaderById(gl, id) {
    var elem = document.getElementById(id);
    if (!elem) {
      error("Failed to create shader from non-existent id '" + id + "'.");
      return null;
    }

    var src = getContentFromElem(elem);

    var shader;
    if (elem.type == "x-shader/x-fragment") {
      shader = gl.createShader(gl.FRAGMENT_SHADER);
    } else if (elem.type == "x-shader/x-vertex") {
      shader = gl.createShader(gl.VERTEX_SHADER);
    } else {
      error("Bad MIME type for shader '" + id + "': " + elem.type + ".");
      return null;
    }

    gl.shaderSource(shader, src);
    gl.compileShader(shader);

    return shader;
  }

  function createProgramByIds(gl, vsId, fsId) {
    var vs = createShaderById(gl, vsId);
    var fs = createShaderById(gl, fsId);
    if (!vs || !fs) {
      return null;
    }

    var prog = gl.createProgram();
    gl.attachShader(prog, vs);
    gl.attachShader(prog, fs);
    gl.linkProgram(prog);

    if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) {
      var str = "Shader program linking failed:";
      str += "\nShader program info log:\n" + gl.getProgramInfoLog(prog);
      str += "\n\nVert shader log:\n" + gl.getShaderInfoLog(vs);
      str += "\n\nFrag shader log:\n" + gl.getShaderInfoLog(fs);
      warning(str);
      return null;
    }

    return prog;
  }

  return {
    setErrorFunc,
    setWarningFunc,

    getWebGL,
    withWebGL2,
    createShaderById,
    createProgramByIds,

    linkProgramByIds(gl, vertSrcElem, fragSrcElem) {
      const prog = gl.createProgram();

      function attachShaderById(type, srcElem) {
        const shader = gl.createShader(type);
        gl.shaderSource(shader, srcElem.innerHTML.trim() + "\n");
        gl.compileShader(shader);
        gl.attachShader(prog, shader);
        prog[type] = shader;
      }
      attachShaderById(gl.VERTEX_SHADER, vertSrcElem);
      attachShaderById(gl.FRAGMENT_SHADER, fragSrcElem);

      gl.linkProgram(prog);
      const success = gl.getProgramParameter(prog, gl.LINK_STATUS);
      if (!success) {
        console.error("Error linking program:");
        console.error("\nLink log: " + gl.getProgramInfoLog(prog));
        console.error(
          "\nVert shader log: " + gl.getShaderInfoLog(prog[gl.VERTEX_SHADER])
        );
        console.error(
          "\nFrag shader log: " + gl.getShaderInfoLog(prog[gl.FRAGMENT_SHADER])
        );
        return null;
      }
      gl.deleteShader(prog[gl.VERTEX_SHADER]);
      gl.deleteShader(prog[gl.FRAGMENT_SHADER]);

      let count = gl.getProgramParameter(prog, gl.ACTIVE_ATTRIBUTES);
      for (let i = 0; i < count; i++) {
        const info = gl.getActiveAttrib(prog, i);
        prog[info.name] = gl.getAttribLocation(prog, info.name);
      }
      count = gl.getProgramParameter(prog, gl.ACTIVE_UNIFORMS);
      for (let i = 0; i < count; i++) {
        const info = gl.getActiveUniform(prog, i);
        prog[info.name] = gl.getUniformLocation(prog, info.name);
      }
      return prog;
    },
  };
})();

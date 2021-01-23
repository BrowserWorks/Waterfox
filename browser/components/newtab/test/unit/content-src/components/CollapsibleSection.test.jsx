import { actionTypes as at } from "common/Actions.jsm";
import { CollapsibleSection } from "content-src/components/CollapsibleSection/CollapsibleSection";
import { ErrorBoundary } from "content-src/components/ErrorBoundary/ErrorBoundary";
import { mount } from "enzyme";
import React from "react";

const DEFAULT_PROPS = {
  id: "cool",
  className: "cool-section",
  title: "Cool Section",
  prefName: "collapseSection",
  collapsed: false,
  document: {
    addEventListener: () => {},
    removeEventListener: () => {},
    visibilityState: "visible",
  },
  dispatch: () => {},
};

describe("CollapsibleSection", () => {
  let wrapper;

  function setup(props = {}) {
    const customProps = Object.assign({}, DEFAULT_PROPS, props);
    wrapper = mount(
      <CollapsibleSection {...customProps}>foo</CollapsibleSection>
    );
  }

  beforeEach(() => setup());

  it("should render the component", () => {
    assert.ok(wrapper.exists());
  });

  it("should render an ErrorBoundary with class section-body-fallback", () => {
    assert.equal(
      wrapper
        .find(ErrorBoundary)
        .first()
        .prop("className"),
      "section-body-fallback"
    );
  });

  it("should have collapsed class if 'prefName' pref is true", () => {
    setup({ collapsed: true });
    assert.ok(
      wrapper
        .find(".collapsible-section")
        .first()
        .hasClass("collapsed")
    );
  });

  it("should fire a pref change event when section title is clicked", done => {
    function dispatch(a) {
      if (a.type === at.UPDATE_SECTION_PREFS) {
        assert.equal(a.data.id, DEFAULT_PROPS.id);
        assert.equal(a.data.value.collapsed, true);
        done();
      }
    }
    setup({ dispatch });
    wrapper
      .find(".click-target")
      .at(0)
      .simulate("click");
  });

  it("should not fire a pref change when section title is clicked if sectionBody is falsy", () => {
    const dispatch = sinon.spy();
    setup({ dispatch });
    delete wrapper.find(CollapsibleSection).instance().sectionBody;

    wrapper
      .find(".click-target")
      .at(0)
      .simulate("click");

    assert.notCalled(dispatch);
  });

  it("should enable animations if the tab is visible", () => {
    wrapper.instance().enableOrDisableAnimation();
    assert.ok(wrapper.instance().state.enableAnimation);
  });

  it("should disable animations if the tab is in the background", () => {
    const doc = Object.assign({}, DEFAULT_PROPS.document, {
      visibilityState: "hidden",
    });
    setup({ document: doc });
    wrapper.instance().enableOrDisableAnimation();
    assert.isFalse(wrapper.instance().state.enableAnimation);
  });

  describe("without collapsible pref", () => {
    let dispatch;
    beforeEach(() => {
      dispatch = sinon.stub();
      setup({ collapsed: undefined, dispatch });
    });
    it("should render the section uncollapsed", () => {
      assert.isFalse(
        wrapper
          .find(".collapsible-section")
          .first()
          .hasClass("collapsed")
      );
    });

    it("should not render the arrow if no collapsible pref exists for the section", () => {
      assert.lengthOf(wrapper.find(".click-target .collapsible-arrow"), 0);
    });

    it("should not trigger a dispatch when the section title is clicked ", () => {
      wrapper
        .find(".click-target")
        .at(0)
        .simulate("click");

      assert.notCalled(dispatch);
    });
  });

  describe("icon", () => {
    it("should use the icon prop value as the url if it starts with `moz-extension://`", () => {
      const icon = "moz-extension://some/extension/path";
      setup({ icon });
      const props = wrapper
        .find(".icon")
        .first()
        .props();
      assert.equal(props.style.backgroundImage, `url('${icon}')`);
    });
    it("should use set the icon-* class if a string that doesn't start with `moz-extension://` is provided", () => {
      setup({ icon: "cool" });
      assert.ok(
        wrapper
          .find(".icon")
          .first()
          .hasClass("icon-cool")
      );
    });
    it("should use the icon `webextension` if no other is provided", () => {
      setup({ icon: undefined });
      assert.ok(
        wrapper
          .find(".icon")
          .first()
          .hasClass("icon-webextension")
      );
    });
  });

  describe("maxHeight", () => {
    const maxHeight = "123px";
    const setState = state =>
      wrapper.setState(Object.assign({ maxHeight }, state || {}));
    const checkHeight = val =>
      assert.equal(
        wrapper.find(".section-body").instance().style.maxHeight,
        val
      );

    it("should have no max-height normally to avoid unexpected cropping", () => {
      setState();

      checkHeight("");
    });
    it("should have a max-height when animating open to a target height", () => {
      setState({ isAnimating: true });

      checkHeight(maxHeight);
    });
    it("should not have a max-height when already collapsed", () => {
      setup({ collapsed: true });

      checkHeight("");
    });
    it("should not have a max-height when animating closed to a css-set 0", () => {
      setup({ collapsed: true });
      setState({ isAnimating: true });

      checkHeight("");
    });
  });
});

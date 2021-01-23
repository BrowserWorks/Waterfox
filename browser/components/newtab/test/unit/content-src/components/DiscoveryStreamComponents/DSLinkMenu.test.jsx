import { mount, shallow } from "enzyme";
import { DSLinkMenu } from "content-src/components/DiscoveryStreamComponents/DSLinkMenu/DSLinkMenu";
import { ContextMenuButton } from "content-src/components/ContextMenu/ContextMenuButton";
import { LinkMenu } from "content-src/components/LinkMenu/LinkMenu";
import React from "react";

describe("<DSLinkMenu>", () => {
  let wrapper;
  let parentNode;

  describe("DS link menu actions", () => {
    beforeEach(() => {
      wrapper = mount(<DSLinkMenu />);
      parentNode = wrapper.getDOMNode().parentNode;
    });

    afterEach(() => {
      wrapper.unmount();
    });

    it("Should remove active on Menu Update", () => {
      // Add active class name to DSLinkMenu parent node
      // to simulate menu open state
      parentNode.classList.add("active");
      assert.equal(parentNode.className, "active");

      wrapper.instance().onMenuUpdate(false);
      wrapper.update();

      assert.isEmpty(parentNode.className);
    });

    it("Should add active on Menu Show", async () => {
      wrapper.instance().nextAnimationFrame = () => {};
      await wrapper.instance().onMenuShow();
      wrapper.update();
      assert.equal(parentNode.className, "active");
    });

    it("Should add last-item to support resized window", async () => {
      const fakeWindow = { scrollMaxX: "20" };
      wrapper = mount(<DSLinkMenu windowObj={fakeWindow} />);
      parentNode = wrapper.getDOMNode().parentNode;
      wrapper.instance().nextAnimationFrame = () => {};
      await wrapper.instance().onMenuShow();
      wrapper.update();
      assert.equal(parentNode.className, "last-item active");
    });

    it("Should call rAF from nextAnimationFrame", () => {
      const fakeWindow = { requestAnimationFrame: sinon.stub() };
      wrapper = mount(<DSLinkMenu windowObj={fakeWindow} />);

      wrapper.instance().nextAnimationFrame();
      assert.calledOnce(fakeWindow.requestAnimationFrame);
    });

    it("should remove .active and .last-item classes from the parent component", () => {
      const instance = wrapper.instance();
      const remove = sinon.stub();
      instance.contextMenuButtonRef = {
        current: {
          parentElement: { parentElement: { classList: { remove } } },
        },
      };
      instance.onMenuUpdate();
      assert.calledOnce(remove);
    });

    it("should add .active and .last-item classes to the parent component", async () => {
      const instance = wrapper.instance();
      const add = sinon.stub();
      instance.nextAnimationFrame = () => {};
      instance.contextMenuButtonRef = {
        current: { parentElement: { parentElement: { classList: { add } } } },
      };
      await instance.onMenuShow();
      assert.calledOnce(add);
    });

    it("should parse args for fluent correctly ", () => {
      const title = '"fluent"';
      wrapper = mount(<DSLinkMenu title={title} />);

      const button = wrapper.find(
        "button[data-l10n-id='newtab-menu-content-tooltip']"
      );
      assert.equal(button.prop("data-l10n-args"), JSON.stringify({ title }));
    });
  });

  describe("DS context menu options", () => {
    const ValidDSLinkMenuProps = {
      site: {},
    };

    beforeEach(() => {
      wrapper = shallow(<DSLinkMenu {...ValidDSLinkMenuProps} />);
    });

    it("should render a context menu button", () => {
      assert.ok(wrapper.exists());
      assert.ok(
        wrapper.find(ContextMenuButton).exists(),
        "context menu button exists"
      );
    });

    it("should render LinkMenu when context menu button is clicked", () => {
      let button = wrapper.find(ContextMenuButton);
      button.simulate("click", { preventDefault: () => {} });
      assert.equal(wrapper.find(LinkMenu).length, 1);
    });

    it("should pass dispatch, onShow, site, options, shouldSendImpressionStats, source and index to LinkMenu", () => {
      wrapper
        .find(ContextMenuButton)
        .simulate("click", { preventDefault: () => {} });
      const linkMenuProps = wrapper.find(LinkMenu).props();
      [
        "dispatch",
        "onShow",
        "site",
        "index",
        "options",
        "source",
        "shouldSendImpressionStats",
      ].forEach(prop => assert.property(linkMenuProps, prop));
    });

    it("should pass through the correct menu options to LinkMenu", () => {
      wrapper
        .find(ContextMenuButton)
        .simulate("click", { preventDefault: () => {} });
      const linkMenuProps = wrapper.find(LinkMenu).props();
      assert.deepEqual(linkMenuProps.options, [
        "CheckBookmarkOrArchive",
        "CheckSavedToPocket",
        "Separator",
        "OpenInNewWindow",
        "OpenInPrivateWindow",
        "Separator",
        "BlockUrl",
      ]);
    });

    it("should pass through the correct menu options to LinkMenu for spocs", () => {
      wrapper = shallow(
        <DSLinkMenu {...ValidDSLinkMenuProps} flightId="1234" />
      );
      wrapper
        .find(ContextMenuButton)
        .simulate("click", { preventDefault: () => {} });
      const linkMenuProps = wrapper.find(LinkMenu).props();
      assert.deepEqual(linkMenuProps.options, [
        "CheckBookmarkOrArchive",
        "CheckSavedToPocket",
        "Separator",
        "OpenInNewWindow",
        "OpenInPrivateWindow",
        "Separator",
        "BlockUrl",
        "ShowPrivacyInfo",
      ]);
    });
  });
});

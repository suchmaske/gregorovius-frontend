import { shallowMount } from "@vue/test-utils";
import LettersDetail from "@/views/LettersDetail.vue";
import { itemDataReg } from "../fixtures/item-data";
import teiHeaderFixture from "../fixtures/tei-header";
import * as service from "../../../src/shared/service";

describe("LettersDetail", () => {
  let wrapper;

  const path = "/letters/G000127";
  const $route = {
    path
  };

  jest.doMock("axios", () => ({
    get: Promise.resolve(teiHeaderFixture)
  }));
  service.dataService.XSLTransform = jest.fn();

  beforeEach(() => {
    wrapper = shallowMount(LettersDetail, {
      mocks: {
        $route
      },
      data() {
        return {
          data: {
            teiHeader: itemDataReg.teiHeader
          },
          loading: false
        };
      }
    });
  });

  afterEach(() => {
    wrapper.destroy();
  });

  it("renders the component", () => {
    expect(wrapper).toBeTruthy();
  });

  it("reads the the German abstract text", () => {
    expect(wrapper.vm.getGermanAbstract()).toBeTruthy();
    expect(wrapper.vm.getGermanAbstract()).toContain("Er hat seinen letzten Brief");
  });

  it("shows the German abstract when it is available", () => {
    const abstractDe = wrapper.find("#abstract-de");
    expect(abstractDe).toBeTruthy();
    expect(abstractDe.text()).toContain("Er hat seinen letzten Brief");
  });

  it.todo("does not show the German abstract when there is none");

  it.todo("reads the English abstract text");

  it.todo("shows the English abstract when it is available");

  it.todo("hides the abstracts when there is neither a German nor an English abstract available");
});

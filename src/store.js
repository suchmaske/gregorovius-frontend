import Vue from "vue";
import Vuex from "vuex";
import { dataService } from "./shared";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    isLoading: false,
    letters: [],
    persons: [],
    places: [],
    works: [],
    fullNameIndex: [],
    selectedRecipient: { label: "", value: "" },
    selectedPlaceReceived: { label: "", value: "" },
    selectedPlaceSent: { label: "", value: "" },
    selectedYears: []
  },
  mutations: {
    SET_LOADING_STATUS(state) {
      state.isLoading = !state.isLoading;
    },
    GET_LETTERS(state, letters) {
      state.letters = letters;
    },
    GET_PERSONS(state, persons) {
      state.persons = persons;
    },
    GET_PLACES(state, places) {
      state.persons = places;
    },
    GET_FULLNAME_INDEX(state, fullNameIndex) {
      state.fullNameIndex = fullNameIndex;
    },
    SET_SELECTED(state, payload) {
      const newModel = { label: state.fullNameIndex[payload.value], value: payload.value };
      switch (payload.entity) {
        case "recipient":
          state.selectedRecipient = newModel;
          break;
        case "placeReceived":
          state.selectedPlaceReceived = newModel;
          break;
        case "placeSent":
          state.selectedPlaceSent = newModel;
          break;
        case "years":
          state.selectedYears = payload.value;
          break;
        default:
          break;
      }
    }
  },
  actions: {
    async loadLettersAction({ commit }) {
      commit("SET_LOADING_STATUS", true);
      const letters = await dataService.getLetters();
      commit("GET_LETTERS", letters);
      commit("SET_LOADING_STATUS", false);
    },
    async loadPersonsAction({ commit }) {
      commit("SET_LOADING_STATUS", true);
      const persons = await dataService.getEntities("persons");
      commit("GET_LETTERS", persons);
      commit("SET_LOADING_STATUS", false);
    },
    async loadFullNameIndexAction({ commit }) {
      const fullNameIndex = await dataService.getFullNameIndex();
      commit("GET_FULLNAME_INDEX", fullNameIndex);
    },
    async setSelectedAction({ commit }, payload) {
      commit("SET_SELECTED", payload);
    },
    async setLoadingStatus({ commit }, value) {
      commit("SET_LOADING_STATUS", value);
    }
  },
  getters: {
    letters: state => state.letters,
    persons: state => state.persons,
    loading: state => state.isLoading,
    fullNameIndex: state => state.fullNameIndex,
    selectedRecipient: state => state.selectedRecipient,
    selectedPlaceReceived: state => state.selectedPlaceReceived,
    selectedPlaceSent: state => state.selectedPlaceSent,
    selectedYears: state => state.selectedYears
  }
});

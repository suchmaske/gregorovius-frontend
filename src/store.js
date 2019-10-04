import Vue from 'vue';
import Vuex from 'vuex';
import { dataService } from './shared';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    isLoading: false,
    letters: [],
    persons: [],
    places: [],
    works: [],
    fullNameIndex: [],
    selectedRecipient: '',
    selectedPlaceReceived: '',
    selectedPlaceSent: '',
    selectedYears: [],
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
      switch (payload.entity) {
        case 'recipient':
          state.selectedRecipient = payload.value;
          break;
        case 'placeReceived':
          state.selectedPlaceReceived = payload.value;
          break;
        case 'placeSent':
          state.selectedPlaceSent = payload.value;
          break;
        case 'years':
          state.selectedYears = payload.value;
          break;
        default:
          break;
      }
    },
  },
  actions: {
    async loadLettersAction({ commit }) {
      commit('SET_LOADING_STATUS');
      const letters = await dataService.getLetters();
      commit('GET_LETTERS', letters);
      commit('SET_LOADING_STATUS');
    },
    async loadFullNameIndexAction({ commit }) {
      commit('SET_LOADING_STATUS');
      const fullNameIndex = await dataService.getFullNameIndex();
      commit('GET_FULLNAME_INDEX', fullNameIndex);
      commit('SET_LOADING_STATUS');
    },
    async setSelectedAction({ commit }, payload) {
      commit('SET_SELECTED', payload);
    },
  },
  getters: {
    letters: state => state.letters,
    fullNameIndex: state => state.fullNameIndex,
    selectedRecipient: state => state.selectedRecipient,
    selectedPlaceReceived: state => state.selectedPlaceReceived,
    selectedPlaceSent: state => state.selectedPlaceSent,
    selectedYears: state => state.selectedYears,
  },
});

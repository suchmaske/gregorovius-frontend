import Vue from 'vue';
import Vuex from 'vuex';
import { dataService } from './shared';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    isLoading: false,
    letters: [],
    persons: [],
    institutions: [],
    places: [],
    works: [],
    fullNameIndex: [],
  },
  mutations: {
    SET_LOADING_STATUS(state) {
      state.isLoading = !state.isLoading;
    },
    GET_LETTERS(state, letters) {
      state.letters = letters;
    },
    GET_FULLNAME_INDEX(state, fullNameIndex) {
      state.fullNameIndex = fullNameIndex;
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
  },
  getters: {
    letters: state => {
      return state.letters;
    },
    fullNameIndex: state => {
      return state.fullNameIndex;
    },
  },
});

import Vue from "vue";
import Router from "vue-router";
import DefaultLayout from "@/layouts/Default.vue";
import Index from "@/views/Index.vue";

import LettersIndex from "@/views/LettersIndex.vue";
import LettersDetail from "@/views/LettersDetail.vue";
import PersonsIndex from "@/views/PersonsIndex.vue";
import PersonsDetail from "@/views/PersonsDetail.vue";
import PlacesIndex from "@/views/PlacesIndex.vue";
import PlacesDetail from "@/views/PlacesDetail.vue";
import WorksIndex from "@/views/WorksIndex.vue";
import WorksDetail from "@/views/WorksDetail.vue";

import Impressum from "@/views/Impressum.vue";
import Project from "@/views/Project.vue";
import Team from "@/views/Team.vue";

import store from "@/store";

import Error404 from "@/views/Error404.vue";
import { nextTick } from "q";

Vue.use(Router);

export default new Router({
  mode: "history",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
  routes: [
    {
      path: "/",
      component: DefaultLayout,
      children: [
        {
          path: "/",
          name: "Index",
          component: Index
        },
        {
          path: "letters",
          name: "Briefe",
          component: LettersIndex,
          async beforeEnter(to, from, next) {
            if (store.getters.fullNameIndex.length == 0) {
              await store.dispatch("loadFullNameIndexAction");
            }
            next();
          }
        },
        {
          path: "letters/:id",
          name: "Brief",
          component: LettersDetail
        },
        {
          path: "persons",
          name: "Personen",
          component: PersonsIndex
        },
        {
          path: "persons/:id",
          name: "Person",
          component: PersonsDetail
        },
        {
          path: "places",
          name: "Orte",
          component: PlacesIndex
        },
        {
          path: "places/:id",
          name: "Ort",
          component: PlacesDetail
        },
        {
          path: "works",
          name: "Werke",
          component: WorksIndex
        },
        {
          path: "works/:id",
          name: "Werk",
          component: WorksDetail
        },
        {
          path: "project",
          name: "Projekt",
          component: Project
        },
        {
          path: "team",
          name: "Team",
          component: Team
        },
        {
          path: "impressum",
          name: "Impressum",
          component: Impressum
        },
        {
          path: "*",
          component: Error404
        }
      ]
    }
  ]
});

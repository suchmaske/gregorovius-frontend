<template>
<q-page padding>
  <div class="row justify-center">
    <div class="col-md-8 col-12 q-py-xl q-gutter-y-lg">
      <q-card class="q-pa-xl" flat>
        <q-card-section>
          <transition
            appear
            enter-active-class="animated fadeIn"
            leave-active-class="animated fadeOut"
          >
            <v-runtime-template :template="title" v-show="showTitle"/>
          </transition>
          <q-inner-loading :showing="visible">
            <q-spinner-gears size="50px" color="primary" />
          </q-inner-loading>
        </q-card-section>
        <q-separator dark />
      </q-card>
    </div>
  </div>
  <div class="row justify-center">
    <div class="col-md-8 col-12 q-pb-xl q-gutter-y-lg">
      <MentionsTable :entityId="this.$route.params.id" entityName="Dieser Titel"/>
    </div>
  </div>
</q-page>
</template>

<script>

import VRuntimeTemplate from 'v-runtime-template';
import { dataService } from '@/shared';
import MentionsTable from '@/components/MentionsTable';
import { API } from '@/shared/config';

export default {
  name: 'PersonsDetail',
  components: {
    MentionsTable,
    VRuntimeTemplate,
  },
  data () {
    return {
      data: [],
      title: '',
      visible: true,
      showTitle: false,
    };
  },

  created () {
    this.getItems(),
    this.getXSLT('WorkTitle', 'title');
  },

  methods: {
    async getItems() {
      try {
        const response = await fetch(
          `${API}${this.$route.path}`, {
            headers: { Accept: 'application/json' },
          },
        );
        const data = await response.json();
        this.data = data;
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    },
    async getXSLT(fileName, targetProp) {
      this[targetProp] = await dataService.XSLTransform(this.$route.path, fileName);
      this.visible = false
      this.showTitle = true
    },
  },
  computed: {
    name() {
      return this.data;
    },
  },
};
</script>

<style>
</style>

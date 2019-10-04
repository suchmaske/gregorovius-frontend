<template>
  <q-page padding>
    <div class="col-8 q-pa-xl q-gutter-y-lg">

      <q-card class="col-md-8 col-12 q-pa-xl" flat bordered>
        <q-card-section>
          <v-runtime-template :template="title"/>
          <div class="text-subtitle3 text-secondary"></div>
        </q-card-section>
        <q-separator dark />
      </q-card>

      <MentionsTable :entityId="this.$route.params.id" entityName="Werk"/>

    </div>
  </q-page>
</template>

<script>

import VRuntimeTemplate from 'v-runtime-template';
import { dataService } from '@/shared';
import MentionsTable from '@/components/MentionsTable';

export default {
  name: 'PersonsDetail',
  components: {
    MentionsTable,
    VRuntimeTemplate,
  },
  data() {
    return {
      data: [],
      title: '',
    };
  },

  mounted() {
    this.getItems(),
    this.getXSLT('WorkTitle', 'title');
  },

  methods: {
    async getItems() {
      try {
        const response = await fetch(
          `http://localhost:8000${this.$route.path}`, {
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

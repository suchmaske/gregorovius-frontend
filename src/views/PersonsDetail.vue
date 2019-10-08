<template>
<q-page padding>
  <div class="row justify-center">
    <div class="col-md-8 col-12 q-py-xl q-gutter-y-lg">
      <q-card class="q-pa-xl" flat>
        <q-card-section>
          <div class="text-h6">{{ name }}</div>
          <div class="text-subtitle3 text-secondary"></div>
        </q-card-section>
        <q-separator dark />
      </q-card>
    </div>
  </div>
  <div class="row justify-center">
    <div class="col-md-8 col-12 q-pb-xl q-gutter-y-lg">
      <MentionsTable :entityId="this.$route.params.id" :entityName="name"/>
    </div>
  </div>
</q-page>
</template>

<script>

import { mapActions, mapState } from 'vuex';
import MentionsTable from '@/components/MentionsTable';

export default {
  name: 'PersonsDetail',
  components: { MentionsTable },
  data() {
    return {
      data: [],
    };
  },

  mounted() {
    this.getItems();
  },

  async beforeMount() {
    if (this.$store.getters.fullNameIndex.length == 0) {
      await this.loadFullNameIndexAction();
    }
  },

  methods: {
    ...mapActions(['loadLettersAction', 'loadFullNameIndexAction']),
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
  },
  computed: {
    fullNameIndex() {
      return this.$store.getters.fullNameIndex;
    },
    name() {
      return this.fullNameIndex[this.$route.params.id];
    },
  },
};
</script>

<style>
</style>

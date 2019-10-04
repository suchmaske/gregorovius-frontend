<template>
  <q-page padding>
    <div class="col-8 q-pa-xl q-gutter-y-lg">

      <q-card class="col-md-8 col-12 q-pa-xl" flat bordered>
        <q-card-section>
          <div class="text-h6">{{ name }}</div>
          <div class="text-subtitle3 text-secondary"></div>
        </q-card-section>
        <q-separator dark />
      </q-card>

      <MentionsTable :entityId="this.$route.params.id" :entityName="name"/>

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
    await this.loadFullNameIndexAction();
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
    name() {
      return this.$store.getters.fullNameIndex[this.$route.params.id];
    },
  },
};
</script>

<style>
</style>

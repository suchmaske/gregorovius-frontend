<template>
    <q-card class="col-md-8 col-12 q-pa-xl" flat bordered>
      <q-table
          v-if="letters.length > 0"
          title="Erwähnt in"
          :data="letters"
          :columns="columns"
          row-key="id"
          :pagination.sync="pagination"
          flat
      >
          <template v-slot:body-cell="props">
          <q-td :props="props" @click.native="$router.push({ path: `/letters/${props.row.id}` })" class="cursor-pointer">{{ props.value }}</q-td>
          </template>
      </q-table>
      <q-banner v-if="letters.length == 0" inline-actions rounded class="bg-warning text-center">
        {{this.$attrs.entityName}} wird in keinem Brief erwähnt.
      </q-banner>
    </q-card>
</template>

<script>

import { mapActions, mapState } from 'vuex';

export default {
  name: 'MentionsTable',
  data() {
    return {
      filter: '',
      loading: true,
      pagination: {
        rowsPerPage: 10,
        sortBy: 'title',
      },
      columns: [
        {
          name: 'title',
          required: true,
          align: 'left',
          field: row => row.properties.title,
        },
      ],
      data: [],
    };
  },

  mounted() {
    this.getItems();
  },

  async beforeMount() {
    await this.loadLettersAction();
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
    fullNameIndex() {
      return this.$store.getters.fullNameIndex;
    },
    name() {
      return this.fullNameIndex[this.$route.params.id];
    },
    letters() {
      const { letters } = this.$store.getters;
      return letters.filter((letter) => {
        let { persons } = letter.properties.mentioned;
        let { places } = letter.properties.mentioned;
        let { works } = letter.properties.mentioned;
        persons = !persons ? [] : persons;
        places = !places ? [] : places;
        works = !works ? [] : works;
        return [...persons, ...places, ...works].includes(this.$attrs.entityId);
      });
    },
  },
};
</script>

<style>
</style>
